###############################################################################
# clang functions
###############################################################################

# update clang resource dir
update_clang_resource_dir() {
  ln -sfn /opt/homebrew/opt/llvm/lib/clang/$(clang -dumpversion) /opt/homebrew/opt/llvm/lib/clang/current
}

