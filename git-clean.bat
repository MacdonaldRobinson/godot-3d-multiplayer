git filter-branch -f --tree-filter 'rm -rf worlds/terrains' HEAD
git filter-branch -f --tree-filter 'rm -rf addons' HEAD
git filter-branch -f --tree-filter 'rm -rf assets' HEAD
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

#git push origin --force --all
#git push origin --force --tags