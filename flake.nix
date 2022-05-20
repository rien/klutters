{
  description = "Klutters - Automatic classification of bank transactions";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlay ]; };
        gems = pkgs.bundlerEnv rec {
          name = "klutters-env";
          ruby = pkgs.ruby_3_1;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
          groups = [ "default" "development" "test" "production" ];
        };
      in
      {
        packages = rec {
          default = klutters;
          klutters = pkgs.stdenv.mkDerivation rec {
            pname = "klutters";
            version = "0.1.0";

            src = pkgs.lib.cleanSourceWith { filter = name: type: !(builtins.elem name [ ".github" "flake.lock" "flake.nix" ]); src = ./.; name = "source"; };

            installPhase = ''
              mkdir $out
              cp -r * $out
            '';

            passthru.env = gems;
          };
        };

        devShells = rec {
          default = klutters;
          klutters = pkgs.devshell.mkShell {
            name = "Klutters";
            imports = [ "${devshell}/extra/language/c.nix" ];
            packages = [
              pkgs.ruby_3_1
              #gems
              pkgs.bundix
              pkgs.nixpkgs-fmt
              pkgs.postgresql_14
              pkgs.yarn
              pkgs.gnumake
            ];
            env = [
              {
                name = "PGDATA";
                eval = "$PWD/tmp/postgres";
              }
              {
                name = "DATABASE_HOST";
                eval = "$PGDATA";
              }
              {
                name = "GEM_HOME";
                eval = "$PWD/vendor/bundle/$(ruby -e 'puts RUBY_VERSION')";
              }
              {
                name = "PATH";
                eval = "$GEM_HOME/bin:$PATH";
              }
            ];
            commands = [
              {
                name = "pg:setup";
                category = "database";
                help = "Setup postgres in project folder";
                command = ''
                  initdb --encoding=UTF8 --no-locale --no-instructions -U postgres
                  echo "listen_addresses = ${"'"}${"'"}" >> $PGDATA/postgresql.conf
                  echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf
                  echo "CREATE USER klutters WITH PASSWORD 'klutters' CREATEDB;" | postgres --single -E postgres
                '';
              }
              {
                name = "pg:start";
                category = "database";
                help = "Start postgres instance";
                command = ''
                  [ ! -d $PGDATA ] && setup-db
                  pg_ctl -D $PGDATA -U postgres start -l log/postgres.log
                '';
              }
              {
                name = "pg:stop";
                category = "database";
                help = "Stop postgres instance";
                command = ''
                  pg_ctl -D $PGDATA -U postgres stop
                '';
              }
              {
                name = "pg:console";
                category = "database";
                help = "Open database console";
                command = ''
                  psql --host $PGDATA -U postgres
                '';
              }
            ];
            language.c = {
              compiler = pkgs.gcc;
              includes = [ pkgs.postgresql_14 pkgs.openssl pkgs.zlib ];
              libraries = [ pkgs.postgresql_14 pkgs.openssl pkgs.zlib ];
            };
          };
        };
      }
    );
}
