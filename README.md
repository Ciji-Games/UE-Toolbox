<br>

<div align = center>

# Unreal Engine toolbox  

[![Badge Fab]][Fab]   
[![Badge CPP]][CPP]   
[![Badge Website]][Website]   

</div>

<br>
<br>


<!---------------------------------------------------------------------------->

[Fab]: https://www.fab.com/sellers/Ciji%20Games
[CPP]: https://www.fab.com/listings/6f1236ea-3587-4cdc-808c-1624ce0b9500
[Website]: https://www.cijigames.com/





<!---------------------------------[ Badges ]---------------------------------->

[Badge Fab]: https://img.shields.io/badge/Fab.com-Seller-blue?style=for-the-badge
[Badge CPP]: https://img.shields.io/badge/C%2B%2B-Generator-orange?style=for-the-badge
[Badge Website]: https://img.shields.io/badge/CijiGames.com-8A2BE2?style=for-the-badge

# Useful links: 

<a href="https://github.com/melqassas/"><img src="https://cdn-icons-png.flaticon.com/512/5396/5396942.png" align="left" height="36" width="36" ></a>
### **[Unreal Engine 5 class UML](https://www.figma.com/design/lVtN4zjquZ1NXZOBGeRmrt/Unreal-Engine-Class-UML?node-id=0-1)**
<br/>





# Utilities How-To:  



<!---------------------------------[ Regen Cpp ]---------------------------------->

## **RegenerateCPP.bat**  
**Purpose:** Cleans and rebuilds the entire C++ solution.  

- **Auto-detects** the `.uproject` file in the script's directory.
- **Configurable paths** for `UnrealVersionSelector.exe` and `UnrealBuildTool.exe`. (edit the file)
- **Delete Folders**: `Intermediate`, `DerivedDataCache`, `Build`, `.vs`, `Binaries`
- **Delete Files**: Solution file (`.sln`), `.vsconfig`
- **Re-Generate & compile** the solution from scratch

### **Steps:**  
1. Place the `.bat` file next to your `.uproject`.  
2. Run the `.bat` file (as administrator if necessary). Ensure Unreal Engine and Visual Studio are closed.  
3. Wait for the process to complete. A message will indicate **"BUILD SUCCESSFUL"** or **"BUILD FAILURE"**.  


---

<!---------------------------------[ batch commit ]---------------------------------->
## **BatchCommit.bat**  
**Purpose:** Automatically stages and commits all local Git changes smaller than 99 MB, grouping them into multiple commits if needed.  
The script **does not** push automatically so that you can review the commits first.

You still need Git installed on your computer or a Git GUI (for example, **Fork** or **GitHub Desktop**).

### **Steps:**  
1. Place the `.bat` file **anywhere inside your Git repository**.  
2. Run the `.bat` file (double-click or execute in CMD).  
3. When prompted, enter a **commit description** (e.g. `FixTextures`, `UpdateAssets`, etc.).  
4. The script will:  
   - **Auto-detect** the `.git` directory (searches up to 4 parent folders).  
   - **Skip large files** over **99 MB** to avoid Git errors and maintain performance.  
   - **Automatically group files** so that each commit stays under **200 MB total**.  
   - **Commit each group separately** with numbered commit messages (e.g. `FixTextures (1)`, `FixTextures (2)` ...).  
5. When done, it displays:  
   ```
   [Done] All steps completed.
   ```  
6. Press any key to close the window.  

---

<!---------------------------------[ renom.exe ]---------------------------------->

## **renom.exe**  
**Purpose:** Provides workflows to rename projects, plugins, targets, and modules. 
[Source repo](https://github.com/UnrealisticDev/Renom) 

### **Steps:**  
1. Download the `.exe`
2. Open your command prompt (as admin if necessary) 
3. navigate to the renom.exe folder with `cd Your/Path/to/exe` and press enter
4. type `renom wizard`
- Example: To rename a BP project choose Project and follow the instructions 
- Example: To rename a BP+CPP project choose Project and follow the instructions, then choose Module and follow the instruction (the module name is in your `.uproject`, open it with the notepad)
- Note: **This tool WILL NOT fix your include if the source folder name was changed!**

---

<!---------------------------------[ build plugins ]---------------------------------->
## **BuildPlugin.bat**  
**Purpose:** Builds and zips a plugin.  

### **Steps:**  
1. Place the `.bat` file inside your project's `Plugins` folder (not inside a specific plugin folder).  
2. Run the `.bat` file (as administrator if necessary). Ensure Unreal Engine and Visual Studio are closed.  
3. Enter the name of the plugin folder you want to build.  
4. If the engine version is not found in the `.uplugin` file, manually enter the engine version.  
- Example: For Unreal Engine **5.3.2**, enter **"5.3"**.  
- If the specified engine version is installed, the `.bat` will locate the required build tools.  
5. *(Optional)* After the build completes, you can choose to zip the plugin. The zip file will be saved in the plugin folder.  


---


<!---------------------------------[ auto scan LFS files ]---------------------------------->
## **checkLFS.bat**  
**Purpose:** scan a UE project, add files that are **more than 100MB and not tracked** to the .gitattribute  

### **Steps:**  
1. Place the `.bat` file next to your `.gitattribute` (after LSF install).  
2. Run the `.bat` file (as administrator if necessary). 
3. Wait for the process to complete. A message will indicate how many files were added to the LFS track list.
  


---


<!---------------------------------[ VS snippets ]---------------------------------->

## **Custom Snippets for Visual Studio**  
**Purpose:** Adds custom snippet macros to Visual Studio.
<div align = center>
<img src="https://github.com/Ciji-Games/UE-Toolbox/blob/main/VS%20Custom%20Snippets/SnippetManager.png?raw=true" width="300"/><img src="https://github.com/Ciji-Games/UE-Toolbox/blob/main/VS%20Custom%20Snippets/customSnippets.gif?raw=true" width="500"/>
</div>
<br>

### **Steps:**  
1. Download the snippet files.  
2. Extract them to a folder of your choice.  
3. Open **Visual Studio** > **Tools** > **Code Snippets Manager**.  
4. In **Visual C++ > Unreal**, locate a `.snippet` path.  
5. The path should resemble:  `C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Snippets\1033\Visual C++\Unreal Engine\`
6. Paste the custom snippets into this folder (administrator access required).  
7. Restart Visual Studio.  


---

<!---------------------------------[ count lines ]---------------------------------->
## **CountLines.bat**  
**Purpose:** Counts the lines in all `.cpp` files and provides a per-file breakdown.  

### **Steps:**  
1. Place the `.bat` file next to your `.uproject`.  
2. Run the `.bat` file (as administrator if necessary).  
3. The script will analyze and count the lines in your C++ project.

