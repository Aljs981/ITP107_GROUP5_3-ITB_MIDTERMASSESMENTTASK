"# ITP107_GROUP5_3-ITB_MIDTERMASSESMENTTASK" 
## 

Follow this simple guide for everyday Git workflows when working on our Flutter project.

---

### 1. First-Time Setup: Cloning the Repository
Do this **once** at the beginning to download the project to your computer.

1. Open your terminal or command line where you want to save the project folder.
2. Run the clone command:
   ```bash
   git clone https://github.com/Aljs981/ITP107_GROUP5_3-ITB_MIDTERMASSESMENTTASK.git
3. Download the dependencies (Important)
   run the command:
   ```bash
   flutter pub get

4. If changes are made in the repo, you should always Pull the latest changes before making your own work.
   run the command:
   ```bash 
   git pull origin main

5. To add the changes you made to the repository you must do These Command in this steps.
   First to stage all the changes run the command:
   ```bash
   git add .
   ```
   Second After Staging all the changes you need to commit with Descriptive message i.e ("refactored the sign up logic")
   Using the command:
   ```bash
   git commit -m "Descriptive Message"
   ```

   Third to finally push the work you've done run the comand:
   ```bash
   git push origin main
   ```
   
