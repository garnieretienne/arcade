# Add a config line at the end of the config file if not already included
add_config_line() {
  local line=$1
  local config_file=$2
  if ! grep "^$line$" $config_file &> /dev/null; then
    echo "$line" >> $config_file
  fi
}

# Replace an exact config line by another in a config file
replace_config_line() {
  local old_line=$1
  local new_line=$2
  local config_file=$3
  sed -i "s|^${old_line}|${new_line}|g" $config_file
}

# Add a config line under another line if not already present in the file
add_new_config_line_under() {
  local line=${1//\//\\\/}
  local new_line=${2//\//\\\/}
  local config_file=$3
  if ! grep "^${new_line}$" $config_file &> /dev/null; then
    sed -i "/^${line}\$/a${new_line}" $config_file
  fi
}

# Download and extract an archive
# Supported extentions: '.tar.gz', '.tar.bz2', '.zip'
download_and_extract_archive() {
  local url=$1
  local ext=${url##*.}
  local dst=$2
  rm --force --recursive $dst
  mkdir --parents $dst
  case $ext in
    gz)
      curl --location $url | tar --extract --gzip --directory $dst
      ;;
    bz2)
      curl --location $url | tar --extract --bzip2 --directory $dst
      ;;
    zip)
      local archive_name=$(basename $url)
      curl --output /tmp/$archive_name $url
      unzip -q /tmp/$archive_name -d $dst
      ;;
  esac
}
