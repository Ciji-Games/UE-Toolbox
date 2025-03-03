# Usage Guide  

## **ILoveUnreal.bat**  
**Purpose:** Cleans and rebuilds the entire C++ solution.  

### **Steps:**  
1. Place the `.bat` file next to your `.uproject`.  
2. Run the `.bat` file (as administrator if necessary). Ensure Unreal Engine and Visual Studio are closed.  
3. Wait for the process to complete. A message will indicate **"BUILD SUCCESSFUL"** or **"BUILD FAILURE"**.  

---

## **Custom Snippets for Visual Studio**  
**Purpose:** Adds custom snippet macros to Visual Studio.  

### **Steps:**  
1. Download the snippet files.  
2. Extract them to a folder of your choice.  
3. Open **Visual Studio** > **Tools** > **Code Snippets Manager**.  
4. In **Visual C++ > Unreal**, locate a `.snippet` path.  
5. The path should resemble:  C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Snippets\1033\Visual C++\Unreal Engine\
6. Paste the custom snippets into this folder (administrator access required).  
7. Restart Visual Studio.  

---

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

## **CountLines.bat**  
**Purpose:** Counts the lines in all `.cpp` files and provides a per-file breakdown.  

### **Steps:**  
1. Place the `.bat` file next to your `.uproject`.  
2. Run the `.bat` file (as administrator if necessary).  
3. The script will analyze and count the lines in your C++ project.  

