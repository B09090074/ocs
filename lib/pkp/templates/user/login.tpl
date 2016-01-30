{**
 * login.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User login form.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="user.login"}
{include file="common/header.tpl"}
{/strip}

{if !$registerOp}
	{assign var="registerOp" value="register"}
{/if}
{if !$registerLocaleKey}
	{assign var="registerLocaleKey" value="user.login.registerNewAccount"}
{/if}

{if $loginMessage}
	<span class="instruct">{translate key="$loginMessage"}</span>
	<br />
	<br />
{/if}

{if $error}
	<span class="formError">{translate key="$error" reason=$reason}</span>
	<br />
	<br />
{/if}

{if $implicitAuth}
	<a id="implicitAuthLogin" href="{url page="login" op="implicitAuthLogin"}">Login</a>
{else}
    
{literal}
    <script type="text/javascript">
        var _setupUsername = function (_input) {
            var _form = _input.form;
            var _email = _form.email.value;
            
            var _user = _email;
            if (_email.indexOf("@") > -1) {
                var _user = _email.substr(0, _email.indexOf("@"));
            }
            
            _form.username.value = _user;
            
            if ($("input[name='role'][value='audience']:checked").length > 0) {
                $('.password-tr input').val(_user);
                alert(_user);
            }
        };
        var _temp_pw = "";
        var _setupRole = function (_radio) {
            if (_radio.value === 'audience') {
                $('.password-tr').hide();
                $('.other-label').hide();
                $('.audience-label').show();
                _temp_pw = $('.password-tr input').val();
                $('.password-tr input').val("");
            }
            else {
                $('.password-tr').show();
                $('.password-tr input').val(_temp_pw);
                $('.other-label').show();
                $('.audience-label').hide();
            }
        };
    </script>
{/literal}
	<form id="signinForm" name="login" method="post" action="{$loginUrl}">
{/if}

<input type="hidden" name="source" value="{$source|strip_unsafe_html|escape}" />

{if ! $implicitAuth}
	<table id="signinTable" class="data">
        <tr>
            {* @TODO 語系 *}
		<td class="label"><label for="loginEmail">身份</label></td>
		<td class="value">
                    <label>
                        <input type="radio" name="role" value="other" onchange="_setupRole(this)" checked="true" /> 
                        管理者、作者、審查委員等
                    </label>
                    {if $schedConfPostPayment}
                    <label>
                        <input type="radio"  name="role" value="audience" onchange="_setupRole(this)" /> 報名與會者
                    </label>
                    {/if}
                </td>
	</tr>
        <tr>
		<td class="label">
                    <label class="other-label" for="loginEmail">{translate key="user.email"} 或 帳號</label>
                    <label class="audience-label" for="loginEmail" style="display:none;">{translate key="user.email"}</label>
                </td>
		<td class="value">
                    <input type="text" id="loginEmail" name="email" value="{$email|escape}" size="20" maxlength="32" class="textField"
                           onchange="_setupUsername(this);"/>
                </td>
	</tr>
	<tr style="display:none;">
		<td class="label"><label for="loginUsername">{translate key="user.username"}</label></td>
		<td class="value"><input type="text" id="loginUsername" name="username" value="{$username|escape}" size="20" maxlength="32" class="textField" /></td>
	</tr>
        <tr class="password-tr">
		<td class="label"><label for="loginPassword">{translate key="user.password"}</label></td>
		<td class="value"><input type="password" id="loginPassword" name="password" value="{$password|escape}" size="20" maxlength="32" class="textField" /></td>
	</tr>
	{if $showRemember}
	<tr valign="middle">
		<td></td>
		<td class="value"><input type="checkbox" id="loginRemember" name="remember" value="1"{if $remember} checked="checked"{/if} /> <label for="loginRemember">{translate key="user.login.rememberUsernameAndPassword"}</label></td>
	</tr>
	{/if}{* $showRemember *}

	<tr>
		<td></td>
		<td><input type="submit" value="{translate key="user.login"}" class="btn btn-primary" /></td>
	</tr>
	</table>

	<p>
		&#187; <a href="{url page="user" op=$registerOp}">{translate key=$registerLocaleKey}</a><br />
		&#187; <a href="{url page="login" op="lostPassword"}">{translate key="user.login.forgotPassword"}</a>
	</p>
{/if}{* !$implicitAuth *}

<script type="text/javascript">
<!--
	document.login.{if $username}loginPassword{else}loginUsername{/if}.focus();
// -->
</script>
</form>

{include file="common/footer.tpl"}
