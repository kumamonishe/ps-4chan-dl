# powershell-4chan-downloader
powershell script to download images from 4chan.org threads
## requirements
1. windows 10
2. you may need to change execution policy before using this script. to do so run the powershell console as admin user and run command ```Set-ExecutionPolicy Unrestricted```. change it back to ```Restricted``` after using the script. 
## usage
1. find a cool thread in 4chan.org 
2. copy its url into clipboard
3. run the script. it will check the clipboard for the link to your thread and dowload images automatically. if the script does not find a valid url to 4chan thread, it will prompt you for such url
4. script saves images in separate directories for each thread. it will create directories in the current directory. the name of new directory will be truncated name of the thread (i.e. content of ```<title>``` tag)
5. script downloads .jpg, .png and .gif images and also webm files, but please keep in mind that webms are big and a donwloading a long thread may take a while
