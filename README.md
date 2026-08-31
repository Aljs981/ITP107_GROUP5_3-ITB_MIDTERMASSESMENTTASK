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

   
   ### 6. If You Can't Push: Use a GitHub Personal Access Token

If `git push origin main` fails because GitHub asks for authentication or rejects your password, you may need to use a **GitHub Personal Access Token (PAT)** instead of your GitHub password.

#### Step 1: Create a Personal Access Token

1. Log in to your GitHub account.

2. Go to **Settings**.

3. Go to **Developer settings**.

4. Select **Personal access tokens**.

5. Create a new token.

6. Give the token permission to access repositories. For a classic token, this usually means selecting the **`repo`** scope.

7. Generate the token.

8. **Copy the token immediately** and keep it somewhere safe. GitHub will not show the token again.

#### Step 2: Push Your Changes

Run:

```bash
 git push origin main
```

When Git asks for your credentials:

```text
Username: YOUR_GITHUB_USERNAME
Password: YOUR_PERSONAL_ACCESS_TOKEN
```

For the password, **paste your token instead of your GitHub password**.

> Important: Your Personal Access Token is private. **Do not send it to your groupmates, commit it to the project, or post it in screenshots.**

#### If Git Still Uses the Wrong Credentials

Windows may have saved an old GitHub password. You can remove the saved GitHub credentials from:

**Windows Settings → Accounts → Credential Manager → Windows Credentials**

Look for GitHub related credentials and remove the old one.

Then try again:

```bash
git push origin main
```

Git should ask you to authenticate again.

### Important for Group Work

Before pushing, always make sure you have the latest version:

```bash
git pull origin main
```

Then make your changes:

```bash
git add .
git commit -m "Descriptive message"
git push origin main
```

**Recommended workflow:**

```text
git pull origin main
        ↓
   Make changes
        ↓
git add .
        ↓
git commit -m "Your message"
        ↓
git push origin main
```
