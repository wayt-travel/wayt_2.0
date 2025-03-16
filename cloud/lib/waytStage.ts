import * as cdk from 'aws-cdk-lib';
import { Stage } from 'aws-cdk-lib';
import { Construct } from 'constructs';

// Define the stage
export class WaytStage extends Stage {
  constructor(scope: Construct, id: string, props?: cdk.StageProps) {
    super(scope, id, props);

    // Add all the stacks here.
  }
}
