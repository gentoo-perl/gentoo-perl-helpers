_gentoo_perl_helpers_init() {
  unset _gentoo_perl_helpers_init

  if type -P portageq >/dev/null; then
    true
  else
    echo "No \`portageq\` in PATH, is sys-apps/portage installed?";
    return 1;
  fi

  if type -P qatom >/dev/null; then
    true
  else
    echo "No \`qatom\` in PATH, is app-portage/portage-utils installed?";
    return 1;
  fi

  if type -P qdepends >/dev/null; then
    true
  else
    echo "No \`qdepends\` in PATH, is app-portage/portage-utils installed?";
    return 1;
  fi

  if type -P xargs >/dev/null; then
    true
  else
    echo "No \`xargs\` in PATH, is sys-apps/findutils installed?";
    return 1;
  fi

  function no_gentoo_perl_helpers() {
    unset no_gentoo_perl_helpers
    unset installed_perl_core
    unset installed_perl_virtual
    unset _gentoo_perl_die
    unset 
  }

  function _gentoo_perl_die() {
    echo -n -e "\e[31;1m * \e[0m" >&2
    echo "$@" >&2
#    echo -e "\e[0m" >&2
    exit 1;
  }
  function _gentoo_perl_info() {
    echo -n -e "\e[32m * \e[0m" >&2
    echo "$@"         >&2
#    echo -e "\e[0m"      >&2
  }

  # Note: use of ( ) subshells is important for flow-control reasons
  function installed_perl_core() {
    (
      set -euo pipefail
      type portageq >/dev/null  || _gentoo_perl_die "No portageq in path, install sys-apps/portage";
      type xargs >/dev/null     || _gentoo_perl_die "No xargs in path, install sys-apps/findutils";
      type qatom >/dev/null     || _gentoo_perl_die "No qatom in path, install app-portage/portage-utils";

      portageq match "${EPREFIX:-/}" "perl-core/*" | xargs qatom --quiet --nocolor --format "%{CATEGORY}/%{PN}"
    ) || return $?
  }
  function installed_perl_virtual() {
    (
      set -euo pipefail
      type portageq >/dev/null  || _gentoo_perl_die "No portageq in path, install sys-apps/portage";
      type xargs >/dev/null     || _gentoo_perl_die "No xargs in path, install sys-apps/findutils";
      type qatom >/dev/null     || _gentoo_perl_die "No qatom in path, install app-portage/portage-utils";

      portageq match "${EPREFIX:-/}" "virtual/perl-*" | xargs qatom --quiet --nocolor --format "%{CATEGORY}/%{PN}"
    ) || return $?
  }
  function installed_deps_perl() {
    (
      set -euo pipefail
      type xargs >/dev/null     || _gentoo_perl_die "No xargs in path, install sys-apps/findutils";
      type qatom >/dev/null     || _gentoo_perl_die "No qatom in path, install app-portage/portage-utils";
      type qdepends >/dev/null  || _gentoo_perl_die "No qdepends in path, install app-portage/portage-utils";

      qdepends --nocolor --depend --quiet --query dev-lang/perl | xargs qatom --quiet --nocolor --format "%{CATEGORY}/%{PN}"
    ) || return $?
  }
  function installed_deps_perl_subslot() {
    local FUNC="installed_deps_perl_subslot"
    (
      ( [[ $# -gt 0 ]] && [[ $# -lt 2 ]] ) || _gentoo_perl_die "${FUNC}: Expected ${FUNC} [perl-version]"
      local subslot=$1; shift
      set -euo pipefail
      type xargs >/dev/null     || _gentoo_perl_die "No xargs in path, install sys-apps/findutils";
      type qatom >/dev/null     || _gentoo_perl_die "No qatom in path, install app-portage/portage-utils";
      type qdepends >/dev/null  || _gentoo_perl_die "No qdepends in path, install app-portage/portage-utils";

      qdepends --nocolor --depend --quiet --query "dev-lang/perl:0/${subslot}=" | xargs qatom --quiet --nocolor --format "%{CATEGORY}/%{PN}"
    ) || return $?
  }

  function gen_perl_upgrade_set() {
    local FUNC="gen_upgrade_set"
    (
      ( [[ $# -gt 0 ]] && [[ $# -lt 2 ]] ) || _gentoo_perl_die "${FUNC}: Expected ${FUNC} [previous-perl-version]"
      local subslot=$1; shift
      set -euo pipefail
      (
        _gentoo_perl_info "Scanning virual/perl-*"
        installed_perl_virtual
        _gentoo_perl_info "Scanning Subslot-Redeps of dev-lang/perl:0/${subslot}"
        installed_deps_perl_subslot "${subslot}"
      ) | sort -u
    )
  }
  function gen_perl_remove_set() {
    local FUNC="gen_remove_set"
    (
      ( [[ $# -gt 0 ]] && [[ $# -lt 2 ]] ) || _gentoo_perl_die "${FUNC}: Expected ${FUNC} [previous-perl-version]"
      local subslot=$1; shift
      set -euo pipefail
      (
        _gentoo_perl_info "Scanning perl-core/ for removals"
        installed_perl_core
      ) | sort -u
    )
  }

  function gen_perl_upgrade_sets() {
    local FUNC="gen_remove_set"
    (
      ( [[ $# -gt 1 ]] && [[ $# -lt 3 ]] ) || _gentoo_perl_die "${FUNC}: Expected ${FUNC} [previous-perl-version] [wanted-version]"
      local subslot="$1"
      shift
      local destsubslot="$1"
      shift;

      set -euo pipefail

      local sets="${ETC_PORTAGE_SETS:-${ETC_PORTAGE:-/etc/portage}/sets}"
      local cleanup="${sets}/perl-cleanup"
      local upgrade="${sets}/perl-upgrade"

      touch -m "${cleanup}" ||_gentoo_perl_die "${FUNC}: Cannot write ${cleanup}"
      touch -m "${upgrade}" ||_gentoo_perl_die "${FUNC}: Cannot write ${upgrade}"

      _gentoo_perl_info "Generating ${cleanup}"
      gen_perl_remove_set "$subslot" >"${cleanup}"
      _gentoo_perl_info "... Done ${cleanup}"

      _gentoo_perl_info "Generating ${upgrade}"
      gen_perl_upgrade_set "$subslot" >"${upgrade}" || _gentoo_perl_die "${FUNC}: No packages detected compiled against dev-lang/perl:0/${subslot}, perhaps you've already upgraded to  0/${destsubslot}"

      _gentoo_perl_info "... Done ${upgrade}"

      _gentoo_perl_info "Created set @perl-cleanup in ${cleanup}"
      _gentoo_perl_info "Created set @perl-upgrade in ${upgrade}"
      _gentoo_perl_info "Assuming both of those were in /etc/portage/sets you can now do"
      _gentoo_perl_info "  emerge -C -va @perl-cleanup"
      _gentoo_perl_info "  emerge -va1 dev-lang/perl:0/${destsubslot} @perl-upgrade"
    )

  }

}
_gentoo_perl_helpers_init
