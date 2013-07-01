"Loading the preview, should be a simulation of the standard bootstrap
after Metacello-Base has been loaded ... which is what the test harndess
does"
| gitCache gitPath |
Transcript cr; show: 'travis---->travisPreviewCI.st'.

gitCache := 'git_cache'.
gitPath := (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
  ifNil: [ ((Smalltalk at: #'FileSystem') workingDirectory / gitCache) pathString ]
  ifNotNil: [:fileDirectoryClass | (fileDirectoryClass default directoryNamed: gitCache ) fullName].

"Load Metacello-Base, so that Metacello is bootstrapped"
MetacelloBuilderTravisCI fileIn: 'Metacello-Base.st'.

"Load the Metacello Tests ... "
[
Metacello new
  configuration: 'MetacelloPreview';
  version: #stable;
  repository: 'filetree://', gitPath, '/metacello-work';
  onConflict: [:ex |
    "allow new version of Metacello to be loaded"
    ex existingProjectRegistration baseName = 'Metacello'
      ifTrue: [ ex allow ].
    ex disallow ];
  load: 'TravisCI'.

"Run the Metacello tests"
(Smalltalk at: #MetacelloPlatform) current authorName: 'testMonkey'. "These tests save code ... need an Author"

Transcript cr; show: 'Starting tests------'.

MetacelloBuilderTravisCI 
  runHarnessFor:  #( 'BaselineOfMetacello' ) 
  successFilename: 'TravisCISuccess.txt' 
  failFilename: 'TravisCIFailure.txt'

] on: Warning
  do: [:ex |
    Transcript cr; show: 'Warning: ', ex description.
    ex resume: true ].
