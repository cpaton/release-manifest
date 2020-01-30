# Release Manifest

Controlled release of applications.  An application release will have many versioned input streams e.g. source code, 3rd party packages, configuration files, deployment scripts spread across many repositories.  Use a document, a release manifest, to define the version of each of these inputs to release of a version of an application.  Using the release manifest it should be possible to reliably recreate the release at any point including any intermediate artifacts e.g. Amazon Machine Images or deployment packages.  Storing release manfiests in Git enables 

* Diffs to see what has changed between two releases
* Easily patch part of the deployment e.g. a configuration file without chaning anything else, giving confidence what is signed off is what is being deployed
* If all inputs into a release artifact e.g. the AMI hasn't changed from release to the next previous output can be re-used

## Sample Manifest

```json
{
  "Key": "1b12dded-0667-4234-a093-3a5603708c33",
  "Name": "1.0.0-2",
  "AMI": [
    {
      "Name": "app-source",
      "Type": "git",
      "Remote": "git@github.com/company/app",
      "Ref": "master",
      "CommitId": "840997ccd397d107e8806f2578d75d5a4e3a9bd9"
    },
    {
      "Name": "packaging-library",
      "Type": "git",
      "Remote": "git@github.com/company/packaging-lib",
      "Ref": "release-1",
      "CommitId": "2a37b01860cabf5834b87e615887231f31ef5eea"
    },
    {
      "Name": "component",
      "Type": "maven",
      "Group": "com.company",
      "ArtifactId": "component",
      "Version": "1.0.0"
    },
    {
      "Name": "golden-image",
      "Type": "golden-image",
      "ImageType": "AmazonLinux2",
      "Ref": "latest"
    }
  ],
  "Deployment": [
    {
      "Name": "app-deployment",
      "Type": "git",
      "Remote": "git@github.com/company/app-deployment",
      "Ref": "master",
      "CommitId": "840997ccd397d107e8806f2578d75d5a4e3a9bd9"
    },
    {
      "Name": "shared-deployment-library",
      "Type": "git",
      "Remote": "git@github.com/company/deployment-lib",
      "Ref": "v1.5.0",
      "CommitId": "c020efa2c21bcc7411c06640ada627b06fa86390"
    }
  ]
}
```