#!/bin/bash
set -exuo pipefail

vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/vuetorrent/vuetorrent/releases/latest" | jq -re .tag_name)
full_version_lib1=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
build_revision_lib1=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${full_version_lib1}/dependency-version.json" | jq -re '.revision')
full_version_lib2=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_2_0)"')
build_revision_lib2=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${full_version_lib2}/dependency-version.json" | jq -re '.revision')
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version_lib2}")
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version_lib1 "${full_version_lib1}" \
    --arg build_revision_lib1 "${build_revision_lib1}" \
    --arg full_version_lib2 "${full_version_lib2}" \
    --arg build_revision_lib2 "${build_revision_lib2}" \
    --arg vuetorrent_version "${vuetorrent_version//v/}" \
    '.version = $version | .full_version_lib1 = $full_version_lib1 | .build_revision_lib1 = $build_revision_lib1 | .full_version_lib2 = $full_version_lib2 | .build_revision_lib2 = $build_revision_lib2 | .vuetorrent_version = $vuetorrent_version' <<< "${json}" | tee VERSION.json
