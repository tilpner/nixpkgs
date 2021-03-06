{ buildPythonPackage
, fetchFromGitHub
, pytest
, six
, tqdm
, pyyaml
, docopt
, requests
, jsonpatch
, args
, schema
, responses
, backports_csv
, isPy3k
, lib
, glibcLocales
, setuptools
}:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "1.9.3";

  # Can't use pypi, data files for tests missing
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    sha256 = "19av6cpps2qldfl3wb9mcirs1a48a4466m1v9k9yhdznqi4zb0ji";
  };

  propagatedBuildInputs = [
    six
    tqdm
    pyyaml
    docopt
    requests
    jsonpatch
    args
    schema
    setuptools
  ] ++ lib.optionals (!isPy3k) [ backports_csv ];

  checkInputs = [ pytest responses glibcLocales ];

  # tests depend on network
  doCheck = false;

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  meta = with lib; {
    description = "A Python and Command-Line Interface to Archive.org";
    homepage = "https://github.com/jjjake/internetarchive";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
