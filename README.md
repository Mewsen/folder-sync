## 🗂️ File Sync Script

This script synchronizes a **main folder** to one or more **backup folders** using `rsync`. It uses a `.folder-sync` file in each directory to identify its role.

### 📄 `.folder-sync` File

Each directory must contain a `.folder-sync` file with **one of the following values**:

* `main` — This is the source directory (only one allowed).
* `backup` — This is a target directory (can have multiple).

---

### 🔧 Usage

```bash
./sync-files.sh <path1> <path2> ...
```

* You can pass **relative or absolute paths**.
* The script will:

  * Identify one `main` folder.
  * Identify all `backup` folders.
  * Sync the contents of the `main` folder to each `backup`, using `rsync`.
  * **Excludes the `.folder-sync` file** during sync, so roles are preserved.

---

### ✅ Example

Assume the following folder structure:

```
project-main/.folder-sync       -> contains: main
project-backup1/.folder-sync    -> contains: backup
project-backup2/.folder-sync    -> contains: backup
```

Run the script like this:

```bash
./sync-files.sh ./project-main ./project-backup1 ./project-backup2
```

This will sync everything from `project-main` to both backups.

---

### ⚠️ Notes

* If more than one `main` is found, the script exits with an error.
* If no `main` or no `backup` is found, the script exits with an error.
* Uses `rsync -av --delete` to mirror the main folder:

  * `--delete` will remove files from the backup that don’t exist in the main.
  * `.folder-sync` is excluded from syncing to avoid role overwrites.
