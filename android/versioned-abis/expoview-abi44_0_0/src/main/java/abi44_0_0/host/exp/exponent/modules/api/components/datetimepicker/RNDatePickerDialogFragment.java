/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package abi44_0_0.host.exp.exponent.modules.api.components.datetimepicker;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.DatePickerDialog.OnDateSetListener;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;
import android.content.DialogInterface.OnClickListener;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import android.widget.DatePicker;

import java.util.Calendar;
import java.util.Locale;

@SuppressLint("ValidFragment")
public class RNDatePickerDialogFragment extends DialogFragment {
  private DatePickerDialog instance;

  @Nullable
  private OnDateSetListener mOnDateSetListener;
  @Nullable
  private OnDismissListener mOnDismissListener;
  @Nullable
  private static OnClickListener mOnNeutralButtonActionListener;

  @Override
  public Dialog onCreateDialog(Bundle savedInstanceState) {
    Bundle args = getArguments();
    instance = createDialog(args, getActivity(), mOnDateSetListener);
    return instance;
  }

  public void update(Bundle args) {
    final RNDate date = new RNDate(args);
    instance.updateDate(date.year(), date.month(), date.day());
  }

  static @NonNull
  DatePickerDialog getDialog(
          Bundle args,
          Context activityContext,
          @Nullable OnDateSetListener onDateSetListener) {

    final RNDate date = new RNDate(args);
    final int year = date.year();
    final int month = date.month();
    final int day = date.day();

    RNDatePickerDisplay display = RNDatePickerDisplay.DEFAULT;

    if (args != null && args.getString(RNConstants.ARG_DISPLAY, null) != null) {
      display = RNDatePickerDisplay.valueOf(args.getString(RNConstants.ARG_DISPLAY).toUpperCase(Locale.US));
    }

    switch (display) {
      case CALENDAR:
      case SPINNER:
        String resourceName = display == RNDatePickerDisplay.CALENDAR
                ? "CalendarDatePickerDialog"
                : "SpinnerDatePickerDialog";
        return new RNDismissableDatePickerDialog(
                activityContext,
                activityContext.getResources().getIdentifier(
                        resourceName,
                        "style",
                        activityContext.getPackageName()),
                onDateSetListener,
                year,
                month,
                day,
                display
        );
      default:
        return new RNDismissableDatePickerDialog(
                activityContext,
                onDateSetListener,
                year,
                month,
                day,
                display
        );
    }
  }

  static DatePickerDialog createDialog(
          Bundle args,
          Context activityContext,
          @Nullable OnDateSetListener onDateSetListener) {

    final Calendar c = Calendar.getInstance();

    DatePickerDialog dialog = getDialog(args, activityContext, onDateSetListener);

    if (args != null && args.containsKey(RNConstants.ARG_NEUTRAL_BUTTON_LABEL)) {
      dialog.setButton(DialogInterface.BUTTON_NEUTRAL, args.getString(RNConstants.ARG_NEUTRAL_BUTTON_LABEL), mOnNeutralButtonActionListener);
    }

    final DatePicker datePicker = dialog.getDatePicker();

    if (args != null && args.containsKey(RNConstants.ARG_MINDATE)) {
      // Set minDate to the beginning of the day. We need this because of clowniness in datepicker
      // that causes it to throw an exception if minDate is greater than the internal timestamp
      // that it generates from the y/m/d passed in the constructor.
      c.setTimeInMillis(args.getLong(RNConstants.ARG_MINDATE));
      c.set(Calendar.HOUR_OF_DAY, 0);
      c.set(Calendar.MINUTE, 0);
      c.set(Calendar.SECOND, 0);
      c.set(Calendar.MILLISECOND, 0);
      datePicker.setMinDate(c.getTimeInMillis());
    } else {
      // This is to work around a bug in DatePickerDialog where it doesn't display a title showing
      // the date under certain conditions.
      datePicker.setMinDate(RNConstants.DEFAULT_MIN_DATE);
    }
    if (args != null && args.containsKey(RNConstants.ARG_MAXDATE)) {
      // Set maxDate to the end of the day, same reason as for minDate.
      c.setTimeInMillis(args.getLong(RNConstants.ARG_MAXDATE));
      c.set(Calendar.HOUR_OF_DAY, 23);
      c.set(Calendar.MINUTE, 59);
      c.set(Calendar.SECOND, 59);
      c.set(Calendar.MILLISECOND, 999);
      datePicker.setMaxDate(c.getTimeInMillis());
    }

    return dialog;
  }

  @Override
  public void onDismiss(DialogInterface dialog) {
    super.onDismiss(dialog);
    if (mOnDismissListener != null) {
      mOnDismissListener.onDismiss(dialog);
    }
  }

  /*package*/ void setOnDateSetListener(@Nullable OnDateSetListener onDateSetListener) {
    mOnDateSetListener = onDateSetListener;
  }

  /*package*/ void setOnDismissListener(@Nullable OnDismissListener onDismissListener) {
    mOnDismissListener = onDismissListener;
  }

  /*package*/ void setOnNeutralButtonActionListener(@Nullable OnClickListener onNeutralButtonActionListener) {
    mOnNeutralButtonActionListener = onNeutralButtonActionListener;
  }
}
