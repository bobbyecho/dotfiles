brew install jenv

# configure path
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# install zulu jdk
brew tap mdogan/zulu

brew install zulu-jdk8
jenv add /Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home

brew install zulu-jdk11
jenv add /Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

brew install zulu-jdk16
jenv add /Library/Java/JavaVirtualMachines/zulu-16.jdk/Contents/Home