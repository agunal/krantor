Automated download initiator for put.io. Fork of https://gitlab.com/klippz/krantor and https://gitlab.com/paulirish/krantor

Fixes broken Docker build, includes improvements made in the paulirish version, updates Go version and Put.io Go API client.

Includes synology build script from paulirish version too, but it is untested.

Only watches one directory and sends to one put.io folder for transfer. So deploy additional containers with respective environment variables as per your needs.

For API Key: https://help.put.io/en/articles/5972538-how-to-get-an-oauth-token-from-put-io

To find your put.io folder id (for `PUTIO_DOWNLOAD_FOLDER_ID` docker environment variable), go into your put.io folder in your browser and copy the number in the URL:
```
https://app.put.io/files/<folder-id>
```

Integrated setup example: https://www.reddit.com/r/putdotio/comments/136u8r2/comment/jisszuf/
>Use Krantor https://gitlab.com/klippz/krantor This gets torrents from sonarr into put.io Set up as a Download Client > Torrent blackhole. Follow readme instructions, however I do separate local folders for Torrent and Watch. My putio download folder is named /dropzone/TV. (I also follow the TRaSH guide for hardlinks)
>
>You need something to automatically download from put.io into your local "downloads" folder. (Probably.) I use rclone. Set up rclone and add a putio remote. Test it with rclone ls and stuff. Here's the rclone command that'll move (copy and delete) files from putio to your machine: rclone -v --config="pathto/rclone.conf" --log-file="pathto/rclone.log" move putio:dropzone/TV /data/Downloads/TV/ --delete-empty-src-dirs I run this every 30 minutes. You probably want to ensure a second invocation doesn't overlap, so.. handle that with your task scheduler mechanism or manually with flock.
>
>I personally never understood how people use Sonarr when all indexers are paid/private except for rarbg (and rarbg frequently 429s). I found a solution with Jackett. In there, I added EZTV, 1337, TPB.. and then hooked Sonarr up to those. Finally both search and rss both work effectively.
>
>If using radarr, repeat all the above with it for movies. I personally get a lot of value from Sonarr, but for movies the chill.institute + download (manually, ftp, rclone, etc) seems fine and radarr seems kinda overkill. But to each their own. :)


---


# Krantor

After searching for something that could help facilitate transfering files from local/apps/services to Putio, nothing corresponded to what I was looking for.
Almost all projects were at least 2years old.

So I decided to do something simple in Go, Krantor

## Table of Contents

* [Installation](#installation)
* [Configuration](#configuration)
* [Advanced Usage](#advanced-usage)
  * [Docker](#docker)
  * [Docker-compose](#docker-compose)
* [How to use with Sonarr/Radarr](#how-to-use-with-sonarr/radarr)
* [Example](#example)

## Installation

Just build the image with the given Dockerfile:

    docker build --no-cache -t krantor .

## Configuration

To make it run, you need to set 3 ENV variables:
```
PUTIO_TOKEN               [Putio Token to communication with their APIs]
PUTIO_WATCH_FOLDER        [Folder to watch for new files]
PUTIO_DOWNLOAD_FOLDER_ID  [ID of the folder in PUTIO where you want to uplaod the file, in general it's 0 but could be something else]
```
To know the DOWNLOAD_FOLDER_ID, just go to your Putio account a chose the folder where you want your file to bbe uploaded
In the URL, you should see something like: `https://app.put.io/files/your_folder_id`

## Advanced Usage

### Docker

```
docker create \
  --name=krantor \
  -e PUTIO_TOKEN=xxx \
  -e PUTIO_WATCH_FOLDER=/torrents \
  -e PUTIO_DOWNLOAD_FOLDER_ID=0 \
  -v /path/to/torrent:/torrents \
  --restart unless-stopped \
  krantor
```

### Docker-compose

```
---
version: "3.7"
services:
  putio:
    image: krantor
    container_name: krantor
    environment:
      - PUTIO_TOKEN=xxx
      - PUTIO_WATCH_FOLDER=/torrents
      - PUTIO_DOWNLOAD_FOLDER_ID=0
    volumes:
      - /path/to/torrent:/torrents
    restart: unless-stopped
```

### How to use with Sonarr/Radarr
What you have to do is:
 * Go to your Radarr/Sonarr configuration
 * `Download Client` tab
 * Add a new `torrent blackhole` client
 * Chose a name
 * In torrent & watch folder, put the same folder you set as `PUTIO_WATCH_FOLDER`
   * If for `PUTIO_WATCH_FOLDER` you set `/torrent`, you should put the same in torrent & watch folder
 * Save magnet file !!
 * Done !

### Example
![alt text](https://i.imgur.com/1jUU1xn.png "Example of logs given by Krantor")

