defaults_keka() {

  # Keka
  local keka_resources="$(mdfind -onlyin / 'kMDItemCFBundleIdentifier==com.aone.keka' | head -1)/Contents/Resources"

  if [ -d "${keka_resources}" ]; then

    local repo='osx-archive-icons'
    local tmp_dir="/tmp/${repo}-master"

    curl --silent --location "https://github.com/reitermarkus/${repo}/archive/master.zip" | ditto -xk - '/tmp'

    sh "${tmp_dir}/_convert_iconsets"

    cp -f "${tmp_dir}"/*.icns "${keka_resources}"

    rm -f "${keka_resources}/extract.png"

    for icon in '7z.7z' 'Bzip.bz' 'Bzip2.bz2' 'Gzip.gz' 'Rar.rar' 'Tar.tar' 'Tbz2.tbz2' 'Tgz.tgz' 'Zip.zip'; do

      local name="${icon%.*}"
      local extension="${icon#*.}"

      local iconset="${tmp_dir}/${extension}.iconset"
      local drop_icon="drop${extension}.png"
      local future_icon="future${name}.png"
      local tab_icon="tab${name}.png"

      if [ -f "${keka_resources}/${drop_icon}" ]; then
        cp -f  "${iconset}/icon_128x128.png" "${keka_resources}/${drop_icon}"
      fi

      if [ -f "${keka_resources}/${tab_icon}" ]; then
        cp -f  "${iconset}/icon_32x32.png" "${keka_resources}/${tab_icon}"
      fi

      if [ -f "${keka_resources}/${future_icon}" ]; then
        cp -f  "${iconset}/icon_32x32.png" "${keka_resources}/${future_icon}"
      fi

    done

    if [ -f "${keka_resources}/compression.png" ]; then
      cp -f "${tmp_dir}/archive.iconset/icon_32x32.png" "${keka_resources}/compression.png"
    fi

    rm -rf "${tmp_dir}"
  fi

}
