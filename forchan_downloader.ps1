Param 
(
    [string]$dest
)
"4chan downloader"

if (!($dest)) 
{
    $dest = $pwd
}
else
{
    if (!([System.IO.Directory]::Exists("$dest")))
    {
        Write-Host "Path $dest not found, will write to $pwd"
        $dest = $pwd;
    }
}

$dest
$threadUri = Get-Clipboard -Format Text;

if (!($threadUri -match '^http:\/\/boards.4channel.org\/.*')) 
{
    $threadUri = Read-Host -Prompt "Enter thread URL with http";
    if (!($threadUri -match '^http:\/\/boards.4channel.org\/.*'))
        {
            "This is not 4chan url: $threadUri. `nExiting."
            Exit(1);
        }
}

try
{
    $Response = Invoke-WebRequest -Uri $threadUri;
}
catch
{
    Write-Host "Connection error: `n";
    Write-Host $error[0].Exception;
    Write-Host "`nCheck the error message above";
    exit; 
}
$title = $($Response.ParsedHtml.getElementsByTagName('title')).innertext;
$dirName = $title -replace '^\/.*\/ - (.*) - .* - .*$','$1';
$dirName = $dirName -replace '[^a-zA-Z0-9]','-';
$html = $Response.Links.Href;

$regex = "^.*(\.jpg$)|(\.png$)|(\.gif$)|(\.webm$)";

if (!(Test-Path $dest\$dirName))
{
    "Creating directory $dest$dirName ...`n"
    New-Item -ItemType  Directory -Path $dest\$dirName | Out-Null;
}
else
{
    "Directory $dirName exists. Enter new name or press ctrl+c for exit.";
    $dirName = Read-Host -Prompt "Enter new directory name.";
    $dirName = $dirName -replace '[^a-zA-Z0-9]','-'; # just in case of slashes or other non-valid shit
    New-Item -ItemType  Directory -Path $dest\$dirName | Out-Null;
}

"Downloading pictures of thread '$title' into directory $dest$dirName ...";

$conter = 0;
foreach ($currentHref in $html) {
    if ($currentHref -match $regex) 
    {
        $Uri = 'http:' + $currentHref;
        $fileName = $currentHref -replace '^.*/(\d+\.[a-zA-Z]{3})','$1';
	    if([System.IO.File]::Exists("$dest\$dirName\$fileName")) { continue; }
	    "Downloading $fileName"
        Invoke-WebRequest -Uri $Uri -OutFile "$dest\$dirName\$fileName";
	    $counter++;
    }
}
"$counter images downloaded`n";
