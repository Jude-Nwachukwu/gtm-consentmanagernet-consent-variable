# ConsentManager.net Consent State – GTM Variable Template

This is a [Google Tag Manager (GTM)](https://tagmanager.google.com/) custom **variable template** that allows you to retrieve the user’s consent state as set by the [ConsentManager.net](https://www.consentmanager.net/) Consent Management Platform (CMP).

The template supports:

* Reading **all** available purpose consent states.
* Reading **a specific** purpose's consent by its purpose ID.
* Optional transformation of boolean outputs into readable values like `"granted"` or `"denied"`.
* Use cases like **tag blocking**, **trigger filtering**, or **Consent Mode integration**.

> Made with 😍 by **Jude Nwachukwu Onyejekwe** for **[DumbData](https://www.dumbdata.co)**

---

## 📆 Features

* 🧹 Works with `__cmp('getCMPData')`
* 🔎 Retrieve **all** or **specific** purpose consent states
* 🧪 Return raw `true/false` or transformed values like `granted/denied`
* ✅ Designed for use in triggers, blocking conditions, or Consent Mode settings

---

## 🚀 How to Import

1. In GTM, go to **Templates** → **Variable Templates** → **New**.
2. Click the 3-dot menu in the top-right corner → **Import**.
3. Select the `template.tpl` file from this repository.
4. Save and name your new variable, e.g., `ConsentManager.net Consent State`.

---

## ⚙️ How to Configure

When configuring the variable in GTM, you'll see the following **fields**:

### 📍 Consent State Check Type (`consentmanagernetConsentStateCheckType`)

* `All Consent Purposes`: Returns a key-value map of all purposes and their consent state.
* `Specific Consent Purpose`: Only checks one specific purpose by ID.

---

### 🆔 Purpose ID (Only if checking a specific purpose) (`consentmanagernetPurposeId`)

* Enter the **purpose ID** (e.g., `C0001`) to look up.

---

### 📂 Include Category Name in Output (`consentmanagernet`)

* If checked, will return an object like:

```json
{
  "C0001": {
    "category": "Statistics",
    "consent": true
  }
}
```

If unchecked, it returns:

```json
{
  "C0001": true
}
```

---

### 🎛 Enable Output Transformation (`consentmanagernetEnableOptionalConfig`)

* Check this to transform `true/false` outputs into readable strings.

---

### 🧰 Transformed Output Options

* **True Value Output (`consentmanagernetTrue`)**:

  * Options: `"granted"` or `"accept"`
* **False Value Output (`consentmanagernetFalse`)**:

  * Options: `"denied"` or `"deny"`
* **Undefined Value Output (`consentmanagernetUndefined`)**:

  * If checked, will treat undefined as `false`.

---

## 💡 Use Cases

### ✅ Use Case 1: Tag Blocking Based on Consent

You can create a trigger condition:

```text
ConsentManager.net Consent State -> equals -> "granted"
```

To only fire tags when consent is granted for a specific category.

---

### ✅ Use Case 2: Consent Mode Setup

If your ConsentManager.net banner is implemented **outside GTM**, use this template to feed consent values into GTM Consent Mode:

```js
gtag('consent', 'update', {
  analytics_storage: 'granted',  // based on consent value from this variable
  ad_storage: 'denied'
});
```

---

### ✅ Output Example

#### All Consent States

```json
{
  "C0001": {
    "category": "Analytics",
    "consent": true
  },
  "C0002": {
    "category": "Marketing",
    "consent": false
  }
}
```

#### Specific Consent State (Transformed)

```json
"granted"
```

---

## 👨‍💻 Author

Made with ❤️ by **[Jude Nwachuwku Onyejekwe](https://www.linkedin.com/in/jude-nwachukwu-onyejekwe/)** for **[DumbData](https://www.dumbdata.co)**
📬 Reach out for GTM help or custom solutions.

---

## 📄 License

APACHE 2.0 License
