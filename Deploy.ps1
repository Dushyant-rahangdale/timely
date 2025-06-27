param(
    [string]$ImageName = "timely",
    [string]$Tag = "latest",
    [int]$Port = 8080
)

$containerName = "${ImageName}-container"

Write-Host "🔍 Verifying .NET SDK installation..."
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    Write-Error "❌ .NET SDK is not installed. Please install it from https://dotnet.microsoft.com/download"
    exit 1
}

Write-Host "`n🧪 Running unit tests..."
dotnet test ./test/SuperService.UnitTests.csproj
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Tests failed. Aborting deployment."
    exit 1
}

Write-Host "`n🐳 Building Docker image: ${ImageName}:${Tag}"
docker build -t ${ImageName}:${Tag} ./src
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Docker build failed. Aborting."
    exit 1
}

Write-Host "`n🧼 Cleaning up existing container (if any)..."
docker rm -f ${containerName} 2>$null | Out-Null

Write-Host "`n🚀 Running Docker container: ${containerName}"
docker run -d -p ${Port}:80 --name ${containerName} ${ImageName}:${Tag}

Write-Host "`n✅ Service is running at: http://localhost:${Port}/time"