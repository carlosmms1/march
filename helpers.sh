available() { command -v "${1:?}" >/dev/null; }
show() { (set -x; "${@:?}"); }