running
tearDown
  super tearDown.
  self tearDownPackages	"double tearDownPackages needed to resolve Issue #202: see https://github.com/dalehenrich/metacello-work/issues/202"