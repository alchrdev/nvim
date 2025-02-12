-- Rename files and automatically update Markdown links.
-- Unify file renaming with link format normalization.

local function get_name_from_file(file_path)
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

    local resolved_path = file_path
    if not file_path:match("^/") then
        resolved_path = current_dir .. "/" .. file_path
    end
    resolved_path = vim.fn.fnamemodify(resolved_path, ":p")

    local f = io.open(resolved_path, "r")
    if not f then
        return nil
    end

    local name = nil
    for _ = 1, 10 do
        local line = f:read("*line")
        if not line then break end
        if line:match("^name:") then
            name = line:match("name: '(.-)'")
            break
        end
    end

    f:close()
    return name
end

local function standardize_links()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local pattern = "(%[[^%]]-%])%(([^%s%)]+)%)"
    local links_updated = false
    local link_resolved = false

    for i, line in ipairs(lines) do
        if line:match("^!%[") then
            goto continue
        end

        local new_line = line:gsub(pattern, function(text, path)
            if path:match("^/") then
                return string.format("%s(%s)", text, path)
            end

            if path:match("^%.%.?/") then
                local name = get_name_from_file(path)
                if name then
                    link_resolved = true
                    return string.format("[%s](%s)", name, path)
                end
                return string.format("%s(%s)", text, path)
            end

            if not path:match("^%.?/") then
                local normalized_path = "./" .. path
                local name = get_name_from_file(normalized_path)
                if name then
                    link_resolved = true
                    return string.format("[%s](%s)", name, normalized_path)
                else
                    return string.format("%s(%s)", text, normalized_path)
                end
            end

            return string.format("%s(%s)", text, path)
        end)

        if new_line ~= line then
            links_updated = true
            lines[i] = new_line
        end

        ::continue::
    end

    if links_updated then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        local msg = link_resolved and "Links updated with YAML names and ./ prefix" or "Links updated with ./ prefix"
        vim.notify(msg, vim.log.levels.INFO)
    end

    return links_updated
end

local function rename_and_update_links()
    local DEBUG_MODE = false
    local function debug(message)
        if DEBUG_MODE then
            vim.notify(message, vim.log.levels.DEBUG)
        end
    end

    local current_file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(current_file, ":h")
    local old_name = vim.fn.fnamemodify(current_file, ":t")
    local project_root = vim.fn.getcwd()
    debug(string.format("Processing file: %s in %s", old_name, project_root))

    local new_name = vim.fn.input("Enter new file name (with extension): ", old_name)
    if new_name == "" then
        vim.notify("Renaming canceled: new name cannot be empty.", vim.log.levels.WARN)
        return
    end

    local path_sep = vim.fn.has('win32') == 1 and '\\' or '/'
    local new_path = dir .. path_sep .. new_name
    if vim.fn.filereadable(new_path) == 1 then
        local confirm = vim.fn.input("File already exists. Overwrite? (y/N): ")
        if confirm:lower() ~= "y" then
            vim.notify("Renaming canceled.", vim.log.levels.INFO)
            return
        end
    end

    if vim.bo.modified then
        vim.cmd('write')
    end

    local function find_markdown_files(directory)
        local files = {}
        local handle

        if vim.fn.has('win32') == 1 then
            handle = io.popen(string.format('dir /b /s /a:-d "%s\\*.md"', directory))
        else
            handle = io.popen(string.format("find '%s' -type f -name '*.md'", directory))
        end

        if handle then
            for file in handle:lines() do
                table.insert(files, file)
            end
            handle:close()
        end
        return files
    end

    local function update_references_in_file(file_path)
        debug(string.format("Checking file for references: %s", file_path))
        local file = io.open(file_path, "r")
        if not file then 
            debug(string.format("Could not open file: %s", file_path))
            return false 
        end
        local content = file:read("*all")
        file:close()

        local escaped_old_name = old_name:gsub("[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
        local patterns = {
            -- [text](file.md)
            "%[([^%]]+)%]%((" .. escaped_old_name .. ")%)",
            -- [text](./file.md)
            "%[([^%]]+)%]%(%.%/(" .. escaped_old_name .. ")%)",
            -- [text](../file.md)
            "%[([^%]]+)%]%(%.%.%/(" .. escaped_old_name .. ")%)",
            -- [text](folder/file.md)
            "%[([^%]]+)%]%([^%)]*%/(" .. escaped_old_name .. ")%)"
        }

        local modified = false
        local new_content = content

        for _, pattern in ipairs(patterns) do
            local function replacer(text, filename)
                debug(string.format("Found match: [%s](%s)", text, filename))
                modified = true
                local path = filename:match("(.*/)" .. escaped_old_name) or ""
                if not path:match("^%.?/") and not path:match("^/") then
                    path = "./" .. path
                end
                return string.format("[%s](%s%s)", text, path, new_name)
            end

            new_content = new_content:gsub(pattern, replacer)
        end

        if modified then
            debug(string.format("Updating references in: %s", file_path))
            local write_file = io.open(file_path, "w")
            if write_file then
                write_file:write(new_content)
                write_file:close()
                vim.cmd('e ' .. file_path)
                standardize_links()
                vim.cmd('w')
                vim.cmd('e #')
                return true
            else
                debug(string.format("Could not write to file: %s", file_path))
            end
        else
            debug(string.format("No references found in: %s", file_path))
        end

        return false
    end

    local success, err = os.rename(current_file, new_path)
    if not success then
        vim.notify(string.format("Error renaming file: %s", err or "unknown error"), vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_buf_set_name(0, new_path)
    vim.notify(string.format("File renamed to %s", new_name), vim.log.levels.INFO)

    local markdown_files = find_markdown_files(project_root)
    local updated_count = 0

    for _, file in ipairs(markdown_files) do
        if update_references_in_file(file) then
            updated_count = updated_count + 1
        end
    end

    if updated_count > 0 then
        vim.notify(string.format("Updated references in %d files", updated_count), vim.log.levels.INFO)
    else
        vim.notify("No references found to update", vim.log.levels.INFO)
    end

    vim.cmd('e')
    standardize_links()
    vim.cmd('w')
end

vim.api.nvim_create_user_command('RenameFile', rename_and_update_links, {})
vim.keymap.set('n', '<leader>ru', rename_and_update_links, { desc = "[R]ename file and update Markdown [U]rls" })
vim.keymap.set('n', '<leader>sl', standardize_links, { desc = "[S]tandardize [L]inks format" })
