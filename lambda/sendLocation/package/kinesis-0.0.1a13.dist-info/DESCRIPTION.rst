# kinesis

A kinesis consumer with color.

![kinesis_gif](https://user-images.githubusercontent.com/4519234/54093775-944dc180-4371-11e9-8c0d-326a3e12b023.gif)

[![Build Status](https://travis-ci.org/davegallant/kinesis.svg?branch=master)](https://travis-ci.org/davegallant/kinesis)
[![PyPI version](https://badge.fury.io/py/kinesis.svg)](https://badge.fury.io/py/kinesis)

## Installation

```bash
pip install kinesis
```

Credentials for AWS are read from `~/.aws/credentials`.

Optionally, config is loaded from `~/.aws/config`.

## Usage

### Consume

Start consuming at the latest shard iterator:

```bash
kinesis consume --stream my-stream
```

### Consume and Capture

If you want to capture:

```bash
kinesis consume --stream my-stream --capture
```

### Produce from a file

```bash
kinesis produce --stream my-stream -f ./my_file.json --repeat 100
```


