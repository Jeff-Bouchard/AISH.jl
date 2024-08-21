const ChatSH::String = "Orion"
const ainame::String = lowercase(ChatSH)
const CONVERSATION_DIR = joinpath(@__DIR__, "..", "conversations")
mkpath(CONVERSATION_DIR)


const IGNORE_FILES = [".gitignore", ".aiignore", ".aishignore"]
const MAX_TOKEN = 4096 # note this should be model specific later on! Note for not streaming the limit can be higher!!???


const PROJECT_FILES = [
    "Dockerfile", "docker-compose.yml", "Makefile", "LICENSE",  
    "README.md", 
    "Gemfile", "Cargo.toml"# , "Project.toml"
]

const FILE_EXTENSIONS = [
    "toml", "ini", "cfg", "conf", "sh", "bash", "zsh", "fish",
    "html", "css", "scss", "sass", "less", "js", "jsx", "ts", "tsx", "php", "vue", "svelte",
    "py", "pyw", "ipynb", "rb", "rake", "gemspec", "java", "kt", "kts", "groovy", "scala",
    "clj", "c", "h", "cpp", "hpp", "cc", "cxx", "cs", "csx", "go", "rs", "swift", "m", "mm",
    "pl", "pm", "lua", "hs", "lhs", "erl", "hrl", "ex", "exs", "lisp", "lsp", "l", "cl",
    "fasl", "jl", "r", "R", "Rmd", "mat", "asm", "s", "dart", "sql", "md", "markdown",
    "rst", "adoc", "tex", "sty", "gradle", "sbt", "xml"
]
const FILTERED_FOLDERS = ["spec", "specs", "examples", "docs", "python", "benchmarks", "node_modules", 
"conversations", "archived", ".git"]
const IGNORED_FILE_PATTERNS = [".log", "config.ini", "secrets.yaml", "Manifest.toml", ".gitignore", ".aiignore", ".aishignore", "Project.toml"] # , "README.md"

get_system() = strip(read(`uname -a`, String))
get_shell() = strip(read(`$(ENV["SHELL"]) --version`, String))



function format_file_content(file)
    content = read(file, String)
    relative_path = relpath(file, pwd())

    ext = lowercase(splitext(file)[2])
    comment_map = Dict(
        ".jl" => ("#", ""), ".py" => ("#", ""), ".sh" => ("#", ""), ".bash" => ("#", ""), ".zsh" => ("#", ""), ".r" => ("#", ""), ".rb" => ("#", ""),
        ".js" => ("//", ""), ".ts" => ("//", ""), ".cpp" => ("//", ""), ".c" => ("//", ""), ".java" => ("//", ""), ".cs" => ("//", ""), ".php" => ("//", ""), ".go" => ("//", ""), ".rust" => ("//", ""), ".swift" => ("//", ""),
        ".html" => ("<!--", "-->"), ".xml" => ("<!--", "-->")
    )

    comment_prefix, comment_suffix = get(comment_map, ext, ("#", ""))

    return """
    $(comment_prefix)File Name: $(relative_path)$(comment_suffix)
    $(comment_prefix)Content: $(comment_suffix)
    $content
    ========================================
    """
end

# function get_all_project_files(path, question="")
#     all_files = get_project_files(path)
#     result = map(file -> format_file_content(file), all_files)
#     return join(result, "\n")
# end

