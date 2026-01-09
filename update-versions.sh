#!/bin/bash
set -exuo pipefail

vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/vuetorrent/vuetorrent/releases/latest" | jq -re .tag_name)
full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version}")
build_revision=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/download/${full_version}/dependency-version.json" | jq -re '.revision')
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version "${full_version}" \
    --arg vuetorrent_version "${vuetorrent_version//v/}" \
    --arg build_revision "${build_revision}" \
    '.version = $version | .full_version = $full_version | .build_revision = $build_revision' | .vuetorrent_version = $vuetorrent_version' <<< "${json}" | tee VERSION.json
