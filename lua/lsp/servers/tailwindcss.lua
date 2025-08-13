return {
    cmd = { 'tailwindcss-language-server', '--stdio' },
    filetypes = {
        'html',
        'css',
        'scss',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
    },
    settings = {
        tailwindCSS = {
            classAttributes = { 'class', 'className', 'classList', 'ngClass' },
            lint = {
                cssConflict = 'warning',
                invalidApply = 'error',
                invalidConfigPath = 'error',
                invalidScreen = 'error',
                invalidTailwindDirective = 'error',
                invalidVariant = 'error',
                recommendedVariantOrder = 'warning',
            },
            validate = true,
        },
    },
}
