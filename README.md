# Dotfiles (MacOS)
my personal dotfiles written in shell script

### Fresh MacOS Install
Install _Command Line Tools for Xcode_. You can download it from the [Apple Developer](https://developer.apple.com/download/more/?=command%20line%20tools) site or using the following command:

```sh
xcode-select --install
```

### Clone the dotfiles
```sh
cd ~ && git clone https://github.com/bobbyecho/dotfiles.git dotfiles
```
or with ssh
```sh
cd ~ && git git@github.com:bobbyecho/dotfiles.git dotfiles
```

### Bootstrap your environment
```sh
cd ~/dotfiles && sh bootstrap.sh
```