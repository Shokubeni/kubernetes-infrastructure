"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var LifecycleEvent;
(function (LifecycleEvent) {
    LifecycleEvent["InstanceLaunching"] = "autoscaling:EC2_INSTANCE_LAUNCHING";
    LifecycleEvent["InstanceTerminating"] = "autoscaling:EC2_INSTANCE_TERMINATING";
    LifecycleEvent["TestNotification"] = "autoscaling:TEST_NOTIFICATION";
})(LifecycleEvent = exports.LifecycleEvent || (exports.LifecycleEvent = {}));
var LifecycleResult;
(function (LifecycleResult) {
    LifecycleResult["Continue"] = "CONTINUE";
    LifecycleResult["Abandon"] = "ABANDON";
})(LifecycleResult = exports.LifecycleResult || (exports.LifecycleResult = {}));
var LifecycleState;
(function (LifecycleState) {
    LifecycleState["Pending"] = "Pending";
    LifecycleState["PendingWait"] = "Pending:Wait";
    LifecycleState["PendingProceed"] = "Pending:Proceed";
    LifecycleState["Quarantined"] = "Quarantined";
    LifecycleState["InService"] = "InService";
    LifecycleState["Terminating"] = "Terminating";
    LifecycleState["TerminatingWait"] = "Terminating:Wait";
    LifecycleState["TerminatingProceed"] = "Terminating:Proceed";
    LifecycleState["Terminated"] = "Terminated";
    LifecycleState["Detaching"] = "Detaching";
    LifecycleState["Detached"] = "Detached";
    LifecycleState["EnteringStandby"] = "EnteringStandby";
    LifecycleState["Standby"] = "Standby";
})(LifecycleState = exports.LifecycleState || (exports.LifecycleState = {}));
var HealthStatus;
(function (HealthStatus) {
    HealthStatus["Healthy"] = "Healthy";
    HealthStatus["Unhealthy"] = "Unhealthy";
})(HealthStatus = exports.HealthStatus || (exports.HealthStatus = {}));
var NodeRole;
(function (NodeRole) {
    NodeRole["MaterNode"] = "master";
    NodeRole["WorkerNode"] = "worker";
})(NodeRole = exports.NodeRole || (exports.NodeRole = {}));
var NodeState;
(function (NodeState) {
    NodeState["RuntimeInstalled"] = "runtime-installed";
    NodeState["NodeInitialized"] = "node-initialized";
})(NodeState = exports.NodeState || (exports.NodeState = {}));
var TagName;
(function (TagName) {
    TagName["NodeRole"] = "smart-gears.io/cluster/role";
    TagName["NodeState"] = "smart-gears.io/cluster/state";
})(TagName = exports.TagName || (exports.TagName = {}));
