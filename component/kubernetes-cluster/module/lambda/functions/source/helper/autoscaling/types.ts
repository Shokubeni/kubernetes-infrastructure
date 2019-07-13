export enum LifecycleEvent {
  InstanceLaunching = 'autoscaling:EC2_INSTANCE_LAUNCHING',
  InstanceTerminating = 'autoscaling:EC2_INSTANCE_TERMINATING',
  TestNotification = 'autoscaling:TEST_NOTIFICATION',
}

export enum LifecycleResult {
  Continue = 'CONTINUE',
  Abandon = 'ABANDON',
}

export enum LifecycleState {
  Pending = 'Pending',
  PendingWait = 'Pending:Wait',
  PendingProceed = 'Pending:Proceed',
  Quarantined = 'Quarantined',
  InService = 'InService',
  Terminating = 'Terminating',
  TerminatingWait = 'Terminating:Wait',
  TerminatingProceed = 'Terminating:Proceed',
  Terminated = 'Terminated',
  Detaching = 'Detaching',
  Detached = 'Detached',
  EnteringStandby = 'EnteringStandby',
  Standby = 'Standby',
}

export enum HealthStatus {
  Healthy = 'Healthy',
  Unhealthy = 'Unhealthy',
}

export enum NodeRole {
  MaterNode = 'master-node',
  WorkerNode = 'worker-node',
}

export enum NodeState {
  InitProcessing = 'init:processing',
  InitAwaiting  = 'init:awaiting',
  InitFinished = 'init:finished',
}

export enum TagName {
  NodeRole = 'smart-gears.io/cluster/role',
  NodeState = 'smart-gears.io/cluster/state',
}
