package abi44_0_0.host.exp.exponent.modules.api.reanimated.nodes;

import android.util.Log;
import abi44_0_0.com.facebook.react.bridge.ReadableMap;
import abi44_0_0.host.exp.exponent.modules.api.reanimated.MapUtils;
import abi44_0_0.host.exp.exponent.modules.api.reanimated.NodesManager;

public class DebugNode extends Node {

  private final String mMessage;
  private final int mValueID;

  public DebugNode(int nodeID, ReadableMap config, NodesManager nodesManager) {
    super(nodeID, config, nodesManager);
    mMessage =
        MapUtils.getString(
            config,
            "message",
            "Reanimated: First argument passed to debug node is either of wrong type or is missing.");
    mValueID =
        MapUtils.getInt(
            config,
            "value",
            "Reanimated: Second argument passed to debug node is either of wrong type or is missing.");
  }

  @Override
  protected Object evaluate() {
    Object value = mNodesManager.findNodeById(mValueID, Node.class).value();
    Log.d("REANIMATED", String.format("%s %s", mMessage, value));
    return value;
  }
}
