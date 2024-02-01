Mega Backup


```
c:/cygwin64/var/cache|/Root/SDF4/AA|0
c:/Users/Fred/Documents|/Root/Fred/Docs|1
c:/Shares|/Root/Backup2/Shares|0
c:/Users/Admin/Documents/Projects|/Root/Backup2/Projects|1
```


- `MEGATOOLS_PATH` - megatools execute file
`MEGATOOLS_PATH='/cygdrive/c/megatools/megatools.exe'`

- `MEGA_CREDENTIALS_PATH` - file with credentials (typical megatools mega.ini)
`MEGA_CREDENTIALS_PATH='/cygdrive/c/megatools/mega.ini'`

- `MEGA_BACKUP_PATHS` - CSV file with backup dirs and settings
`MEGA_BACKUP_PATHS='/cygdrive/c/megatools/mega_server_backup_paths.ini'`

mega_server_backup_paths.ini:
```
c:/cygwin64/var/cache|/Root/SDF4/AA|0
c:/Users/Fred/Documents|/Root/Fred/Docs|1
c:/Shares|/Root/Backup2/Shares|0
c:/Users/Admin/Documents/Projects|/Root/Backup2/Projects|1
```
1-st column is local path 
2-nd column is mega path (Should be started as `/Root`)
3-rd column is mode of backup
  - 0 - copy missing subdirs
  - 1 - copy all dirs to subdir with date like name
  - 3 - copy all files from this dir to OUTPUT dir 
