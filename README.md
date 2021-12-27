# multi-speedtest
Multi speedtest base on bench.sh with some modification on script ~

# Ho To Use

Run this command ~~

```
wget -qO- https://raw.githubusercontent.com/leonyonz/multi-speedtest/master/script.sh | bash
```

or

```
curl -Lso- https://raw.githubusercontent.com/leonyonz/multi-speedtest/master/script.sh | bash
```

The result must be like this:

![](https://cdn-blinux.s3-id-jkt-1.kilatstorage.id/post/leon/result-speed.png)

# Change the speedtest server

First you need to clone this repository, and edit the `script.sh` files, you can search the servers id from this page: [Speedtest List Server](https://williamyaps.github.io/wlmjavascript/servercli.html)

The line that you must edit:

```bash
speed() {
    speed_test '' 'Speedtest.net'
    speed_test '7582'  'Telkom JKT    ID'
    speed_test '797'  'Biznet  ID'
    speed_test '20637' 'OVH Cloud  SG'
    speed_test '4802' 'FirstMedia  ID'
    speed_test '12807' 'CBN JKT  ID'
    speed_test '16398' 'CN Mobile   CN'
    speed_test '3242'  'Netherland   NL'
    speed_test '14623' 'Japan      JP'
}
```

**Note:** Change the number with server id.

Cheers ~~
