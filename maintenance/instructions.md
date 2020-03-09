# Building Zoning Tax Lots
1. Data loading
2. Trigger a build
3. QAQC

***

## 1.  Data Loading 
(coming soon ...) 

***

### 2. Trigger a build
+ Once step 1 is complete, head over to the front page of the repository and navigate into maintenance.
![landing](images/landingpage.png)
+ click into `log.md` and you will see the following files: 
    + `instructions.md`
    + `log.md`
+ To edit the file and add a new entry of build log, click the pencil button in the red box
![editlog](images/editlog.png)
+ A file editor will pop open and now you can add a new entry of build log. Make sure you are following the format highlighted in the screenshot below
![makeedits](images/makeedits.png) 
+ Once you are done editing `log.md`, you are ready to commit to change to `master` and trigger the build. 
![commit](images/commit.png) 
for the commit title, you can indicate the date and other information. and make sure you include `[build]` in the commit message so that github actions can be triggered (github actions is smart and would only trigger a build when `[build]` is mentioned in the commit message). Don't forget to click __commit changes__ whe nyou are done.
+ Now head to github actions
![action_tab](images/action_tab.png)
and you will see a fresh build of zoningtaxlots has been triggered
![action](images/action.png)
