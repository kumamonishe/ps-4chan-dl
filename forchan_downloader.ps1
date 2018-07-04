"4chan downloader`n"

$threadUri = Get-Clipboard -Format Text;
if (!($threadUri -match '^http:\/\/boards.4chan.org\/.*')) {
$threadUri = Read-Host -Prompt "Enter thread URL with http";
}
$Response = Invoke-WebRequest -Uri $threadUri;

$title = $($Response.ParsedHtml.getElementsByTagName('title')).innertext;
$dirName = $title -replace '^\/.*\/ - (.*) - .* - .*$','$1';
$dirName = $dirName -replace '[^a-zA-Z0-9]','-';
$html = $Response.Links.Href;

$regex = "^.*(\.jpg$)|(\.png$)|(\.gif$)|(\.webm$)";

if (!(Test-Path $pwd\$dirName))
{
  "Creating directory $pwd\$dirName ...`n"
  New-Item -ItemType  Directory -Path $pwd\$dirName | Out-Null;
}
else
{
  "Directory $dirName exists. Enter new name or press ctrl+c for exit.";
  $dirName = Read-Host -Prompt "Enter new directory name.";
  $dirName = $dirName -replace '[^a-zA-Z0-9]','-'; # just in case of slashes or other non-valid shit
  New-Item -ItemType  Directory -Path $pwd\$dirName | Out-Null;
}

"Downloading pictures of thread '$title' into directory $dirName ...";

$conter = 0;
foreach ($currentHref in $html) {
    if ($currentHref -match $regex) {
        $Uri = 'http:' + $currentHref;
        $fileName = $currentHref -replace '^.*/(\d+\.[a-zA-Z]{3})','$1';
	if([System.IO.File]::Exists("$pwd\$dirName\$fileName")) { continue; }
	"Downloading $fileName"
        Invoke-WebRequest -Uri $Uri -OutFile "$pwd\$dirName\$fileName";
	$counter++;
    }
}
"$counter images downloaded`n";
