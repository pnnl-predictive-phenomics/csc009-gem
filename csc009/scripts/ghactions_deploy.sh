#!/usr/bin/env bash

# Do NOT set -v or -x or your GitHub API token will be leaked!
#set -ue # exit with nonzero exit code if anything fails

echo "Parse memote.ini for values."
deployment=$(awk -F '=' '{if (! ($0 ~ /^;/) && $0 ~ /deployment/) print $2}' memote.ini | tr -d ' ')
location=$(awk -F '=' '{if (! ($0 ~ /^;/) && $0 ~ /location/) print $2}' memote.ini | tr -d ' ')

echo "Deployment '${deployment}'"
echo "Location '${location}'"
echo "repository '${GITHUB_REPOSITORY}'"

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "${GITHUB_ACTOR}"

if [[ "${GITHUB_EVENT_NAME}" == "pull_request" || "${GITHUB_REPOSITORY}" != "pnnl-predictive-phenomics/csc009-gem" ]]; then
    echo "Untracked build."
    memote run --ignore-git
		echo "Skip deploy."
    exit 0
else
		# Always need the deployment branch available locally for storing results.
		echo "Checking  if deployment branch ${deployment} is available"
		git checkout "${deployment}"
		echo "Back to base ${HEAD_REF}"
		git checkout ${HEAD_REF}
		echo "Tracked build."
		mkdir -p results
		memote run
		echo "Start deploy to ${deployment}..."
fi

# Generate a snapshot report on the deployment branch.
snapshot_output="snapshot_report.html"
git checkout "${deployment}"
echo "Generating snapshot report '${snapshot_output}'"
memote report snapshot --filename="${snapshot_output}"

# Generate the history report on the deployment branch.
history_output="history_report.html"
git checkout "${deployment}"
echo "Generating updated history report '${history_output}'."
memote report history --filename="${history_output}"

# Generate the diff report on the deployment branch.
diff_output="diff_report.html"
git checkout "${deployment}"
echo "Generating updated diff report '${diff_output}'."
memote report diff --filename="${diff_output}"

git add "${snapshot_output}"
git add "${history_output}"
git add "${diff_output}"
git commit -m "Github actions report # ${GITHUB_SHA}"
git push --quiet "https://github.com/${GITHUB_REPOSITORY}.git" "${deployment}" > /dev/null
echo "Memote report was generated at https://pnnl-predictive-phenomics/${GITHUB_REPOSITORY}"
