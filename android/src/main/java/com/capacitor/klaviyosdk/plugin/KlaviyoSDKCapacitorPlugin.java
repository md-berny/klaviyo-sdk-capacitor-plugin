package com.capacitor.klaviyosdk.plugin;

import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.klaviyo.analytics.Klaviyo;
import com.klaviyo.analytics.model.ProfileKey;

@CapacitorPlugin(name = "KlaviyoSDKCapacitor")
public class KlaviyoSDKCapacitorPlugin extends Plugin {

    private KlaviyoSDKCapacitor implementation = new KlaviyoSDKCapacitor();

    @PluginMethod
    public void initSDK(PluginCall call) {
        try {
            String key = call.getString("klaviyoKey");
            Klaviyo.INSTANCE.initialize(key, getActivity().getApplicationContext());
            JSObject ret = new JSObject();
            ret.put("result", key);
            call.resolve(ret);
        } catch (Error e) {
            JSObject ret = new JSObject();
            ret.put("result", false);
            call.resolve(ret);
        }
    }

    @PluginMethod
    public void setUser(PluginCall call) {
        try {
            String email = call.getString("email");
            String firstName = call.getString("firstName");
            Klaviyo.INSTANCE.setEmail(email).setProfileAttribute(ProfileKey.FIRST_NAME.INSTANCE, firstName);
            JSObject ret = new JSObject();
            ret.put("result", email);
            call.resolve(ret);
        } catch (Error e) {
            JSObject ret = new JSObject();
            ret.put("result", false);
            call.resolve(ret);
        }
    }

    @PluginMethod
    public void setPushToken(PluginCall call) {
        try {
            String token = call.getString("token");
            Klaviyo.INSTANCE.setPushToken(token);
            JSObject ret = new JSObject();
            ret.put("token", token);
            call.resolve(ret);
        } catch (Error e) {
            JSObject ret = new JSObject();
            ret.put("token", false);
            call.resolve(ret);
        }
    }

    @PluginMethod
    public void resetProfile(PluginCall call) {
        try {
            Klaviyo.INSTANCE.resetProfile();
            JSObject ret = new JSObject();
            Log.d("KlaviyoReset", "reset success");
            ret.put("result", true);
            call.resolve(ret);
        } catch (Error e) {
            JSObject ret = new JSObject();
            Log.d("KlaviyoReset", "reset failed");
            ret.put("result", false);
            call.resolve(ret);
        }
    }
}
