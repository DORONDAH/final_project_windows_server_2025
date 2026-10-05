param(
    [Parameter(Mandatory=$true)]
    [string]$input_file,
    
    [string]$output_file
)

# Resolve input_file to absolute path
if (-not [System.IO.Path]::IsPathRooted($input_file)) {
    $input_path = Join-Path (Get-Location).Path $input_file
} else {
    $input_path = $input_file
}

# Resolve output_file
if ($output_file) {
    if (-not [System.IO.Path]::IsPathRooted($output_file)) {
        $output_path = Join-Path (Get-Location).Path $output_file
    } else {
        $output_path = $output_file
    }
} else {
    # Change extension to .md
    $output_path = [System.IO.Path]::ChangeExtension($input_path, '.md')
}

# Get directories
$input_dir = Split-Path $input_path
$output_dir = Split-Path $output_path

# Build the docker argument list
$dockerArgs = @("run", "--rm")

# Determine mount arguments and container paths
if ($input_dir -eq $output_dir) {
    # Same directory, mount once
    $dockerArgs += "-v"
    $dockerArgs += ("{0}:/data" -f $input_dir)
    $input_path_in_container = "/data/$(Split-Path $input_path -Leaf)"
    $output_path_in_container = "/data/$(Split-Path $output_path -Leaf)"
} else {
    # Different directories, mount both
    $dockerArgs += "-v"
    $dockerArgs += ("{0}:/data/input" -f $input_dir)
    $dockerArgs += "-v"
    $dockerArgs += ("{0}:/data/output" -f $output_dir)
    $input_path_in_container = "/data/input/$(Split-Path $input_path -Leaf)"
    $output_path_in_container = "/data/output/$(Split-Path $output_path -Leaf)"
}

# Add the image and command arguments
$dockerArgs += "pdf2md:latest"
$dockerArgs += "-i"
$dockerArgs += $input_path_in_container
$dockerArgs += "-o"
$dockerArgs += $output_path_in_container

# Debug output
Write-Host "Input path: $input_path"
Write-Host "Output path: $output_path"
Write-Host "Input dir: $input_dir"
Write-Host "Output dir: $output_dir"
Write-Host "Input path in container: $input_path_in_container"
Write-Host "Output path in container: $output_path_in_container"
Write-Host "Docker arguments: $dockerArgs"

# Run the container
& docker @dockerArgs