{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  glib,
  libfprint,
  polkit,
  systemd,
  pam,
  libpam-wrapper,
  dbus
}:

stdenv.mkDerivation rec {

  pname = "pam_fprint_grosshack";
  version = "0.3.0";
  outputs = [ "out" ];

  src = fetchurl {
    url = "https://gitlab.com/mishakmak/pam-fprint-grosshack/-/archive/v${version}/pam-fprint-grosshack-v0.3.0.tar.gz";
    sha256 = "sha256-5NiVV0o0dkc6SsWgKT09/zgMw8lZtWTlSUqV2qnYsV8=";
  };
  
  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ glib dbus libfprint polkit systemd pam libpam-wrapper ];


  mesonFlags = [
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  PKG_CONFIG_DBUS_1_INTERFACES_DIR = "${placeholder "out"}/share/dbus-1/interfaces";
  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";
  PKG_CONFIG_DBUS_1_DATADIR = "${placeholder "out"}/share";

  meta = {
    description = "PAM Fprint module which implements the simultaneous password and fingerprint behaviour";
    homepage = "https://gitlab.com/mishakmak/pam-fprint-grosshack";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ agvantibo ];
  };
}

