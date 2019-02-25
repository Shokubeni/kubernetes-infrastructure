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
  MaterNode = 'master',
  WorkerNode = 'worker',
}

export enum NodeState {
  RuntimeInstalled = 'runtime-installed',
  NodeInitialized = 'node-initialized',
}

export enum TagName {
  NodeRole = 'cluster/node-role',
  NodeState = 'cluster/node-state',
}
