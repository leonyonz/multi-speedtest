#!/usr/bin/env bash
#
# Description: Auto test download & I/O speed script
#
# Copyright (C) 2015 - 2020 Teddysun <i@teddysun.com>
# Thanks: LookBack <admin@dwhd.org>
# URL: https://teddysun.com/444.html
#


trap _exit INT QUIT TERM

_red() {
    printf '\033[0;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[0;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[0;31;33m%b\033[0m' "$1"
}

_blue() {
    printf '\033[0;31;36m%b\033[0m' "$1"
}

_exists() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}

_64bit(){
    if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ]; then
        return 0
    else
        return 1
    fi
}

_exit() {
    _red "\nThe script has been terminated.\n"
    # clean up
    rm -fr speedtest.tgz speedtest-cli benchtest_*
    exit 1
}


next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    local nodeName="$2"
    [ -z "$1" ] && ./speedtest-cli/speedtest --progress=no --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1 || \
    ./speedtest-cli/speedtest --progress=no --server-id=$1 --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1
    if [ $? -eq 0 ]; then
        local dl_speed=$(awk '/Download/{print $3" "$4}' ./speedtest-cli/speedtest.log)
        local up_speed=$(awk '/Upload/{print $3" "$4}' ./speedtest-cli/speedtest.log)
        local latency=$(awk '/Latency/{print $2" "$3}' ./speedtest-cli/speedtest.log)
        if [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
            printf "\033[0;33m%-18s\033[0;32m%-18s\033[0;31m%-20s\033[0;36m%-12s\033[0m\n" " ${nodeName}" "${up_speed}" "${dl_speed}" "${latency}"
        fi
    fi
}

speed() {
    speed_test '13362' 'Speedtest.net'
    speed_test '1372'  'Telkom SBY    ID'
    speed_test '38128' 'Biznet SBY  ID'
    speed_test '5935' 'My Republic  SG'
    speed_test '4802' 'FirstMedia  ID'
    speed_test '12807' 'CBN JKT  ID'
    speed_test '15248' 'Toronto   CA'
    speed_test '3242'  'Netherland   NL'
    speed_test '14623' 'Japan      JP'
}

ipv4_info() {
    local org="$(wget -q -T10 -O- ipinfo.io/org)"
    local city="$(wget -q -T10 -O- ipinfo.io/city)"
    local country="$(wget -q -T10 -O- ipinfo.io/country)"
    local region="$(wget -q -T10 -O- ipinfo.io/region)"
    [[ -n "$org" ]] && echo " Organization          : $(_blue "$org")"
    [[ -n "$city" && -n "country" ]] && echo " Location              : $(_blue "$city / $country")"
    [[ -n "$region" ]] && echo " Region                : $(_blue "$region")"
}

install_speedtest() {
    if  [ ! -e "./speedtest-cli/speedtest" ]; then
        _64bit && sys_bit=x86_64 || sys_bit=i386
        url1="https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-${sys_bit}-linux.tgz"
        url2="https://dl.lamp.sh/files/ookla-speedtest-1.0.0-${sys_bit}-linux.tgz"
        wget --no-check-certificate -q -T10 -O speedtest.tgz ${url1}
        if [ $? -ne 0 ]; then
            wget --no-check-certificate -q -T10 -O speedtest.tgz ${url2}
            [ $? -ne 0 ] && _red "Error: Failed to download speedtest-cli.\n" && exit 1
        fi
        mkdir -p speedtest-cli && tar zxf speedtest.tgz -C ./speedtest-cli && chmod +x ./speedtest-cli/speedtest
        rm -f speedtest.tgz
    fi
}

! _exists "wget" && _red "Error: wget command not found. You must be install wget command at first.\n" && exit 1

next
install_speedtest && printf "%-18s%-18s%-20s%-12s\n" " Node Name" "Upload Speed" "Download Speed" "Latency"
speed && rm -fr speedtest-cli
next
