package abi44_0_0.host.exp.exponent.modules.api.components.reactnativestripesdk

import abi44_0_0.com.facebook.react.bridge.ReadableArray
import abi44_0_0.com.facebook.react.bridge.ReadableMap
import abi44_0_0.com.facebook.react.common.MapBuilder
import abi44_0_0.com.facebook.react.uimanager.SimpleViewManager
import abi44_0_0.com.facebook.react.uimanager.ThemedReactContext
import abi44_0_0.com.facebook.react.uimanager.annotations.ReactProp

class CardFormViewManager : SimpleViewManager<CardFormView>() {
  override fun getName() = "CardForm"

  private var reactContextRef: ThemedReactContext? = null

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> {
    return MapBuilder.of(
      CardFocusEvent.EVENT_NAME, MapBuilder.of("registrationName", "onFocusChange"),
      CardFormCompleteEvent.EVENT_NAME, MapBuilder.of("registrationName", "onFormComplete")
    )
  }

  override fun receiveCommand(root: CardFormView, commandId: String?, args: ReadableArray?) {
    when (commandId) {
      "focus" -> root.requestFocusFromJS()
      "blur" -> root.requestBlurFromJS()
      "clear" -> root.requestClearFromJS()
    }
  }

  @ReactProp(name = "dangerouslyGetFullCardDetails")
  fun setDangerouslyGetFullCardDetails(view: CardFormView, dangerouslyGetFullCardDetails: Boolean = false) {
    view.setDangerouslyGetFullCardDetails(dangerouslyGetFullCardDetails)
  }

  @ReactProp(name = "postalCodeEnabled")
  fun setPostalCodeEnabled(view: CardFormView, postalCodeEnabled: Boolean = false) {
    view.setPostalCodeEnabled(postalCodeEnabled)
  }

  // @ReactProp(name = "placeholder")
  // fun setPlaceHolders(view: CardFormView, placeholder: ReadableMap) {
  //   view.setPlaceHolders(placeholder);
  // }

  @ReactProp(name = "autofocus")
  fun setAutofocus(view: CardFormView, autofocus: Boolean = false) {
    view.setAutofocus(autofocus)
  }

  @ReactProp(name = "cardStyle")
  fun setCardStyle(view: CardFormView, cardStyle: ReadableMap) {
    view.setCardStyle(cardStyle)
  }

  override fun createViewInstance(reactContext: ThemedReactContext): CardFormView {
    val stripeSdkModule: StripeSdkModule? = reactContext.getNativeModule(StripeSdkModule::class.java)
    val view = CardFormView(reactContext)

    reactContextRef = reactContext

    stripeSdkModule?.cardFormView = view
    return view
  }

  override fun onDropViewInstance(view: CardFormView) {
    super.onDropViewInstance(view)

    val stripeSdkModule: StripeSdkModule? = reactContextRef?.getNativeModule(StripeSdkModule::class.java)
    stripeSdkModule?.cardFormView = null
    reactContextRef = null
  }
}
