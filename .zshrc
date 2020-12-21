# git aliases
alias s='git status'
alias pull='git pull --rebase'
alias spull='git stash && git pull --rebase'
alias spush='git push && git stash pop'
alias spop='git stash pop'
alias stash='git stash'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias rm-pl='git checkout -- package-lock.json'

# misc aliases
alias cy:run:log='npm run cy:run -- --browser chrome --headless 2>&1 | tee cypress.log' # run cypress and add all logs to file

# functions
cyTest() {
	npm run cy:run -- --spec $1 --browser chrome --headless
}

listDatabases() {
	psql -d postgres -c "SELECT pg_database.datname FROM pg_database" | egrep "^[ ][a-zA-Z_0-9]+$" | grep -v "postgres" | grep -v "template" | sort | while IFS= read -r db;do
		echo "${db## }"
	done
}

isMerged() {
	merge_destination_branch=$1
	merge_source_branch=$2
	
	merge_base=$(git merge-base $merge_destination_branch $merge_source_branch)
	merge_source_current_commit=$(git rev-parse $merge_source_branch)
	if [[ $merge_base = $merge_source_current_commit ]]
	then
		echo $merge_source_branch is merged into $merge_destination_branch
		return 0
	else
		echo $merge_source_branch is not merged into $merge_destination_branch
		return 1
	fi
}

commitIsOnBranch() {
	hash=$1
	branch=HEAD
	if git merge-base --is-ancestor $hash $branch; then
		echo true
	else
		echo false
	fi
}
