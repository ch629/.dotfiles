local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
})

ls.add_snippets("go", {
	-- Func
	-- TODO: Recursive args?
	s({ trig = "func", dscr = "a standard function" }, {
		t("func "),
		i(1, "name"),
		t("("),
		c(2, {
			t(""),
			i(nil, "ctx context.Context"),
		}),
		t(") "),
		c(3, {
			t(""),
			i(nil, "error"),
			sn(nil, {
				t("("),
				i(1, "returns"),
				t(")"),
			}),
		}),
		t({ " {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Receiver func
	-- TODO: Add args, return
	s({ trig = "funcr", dscr = "a receiver function" }, {
		t("func ("),
		i(1, "r receiver"),
		t(") "),
		i(2, "name"),
		t("("),
		c(3, {
			t(""),
			i(nil, "ctx context.Context"),
		}),
		t({ ") {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Start and end span
	s({ trig = "span", dscr = "a otel span" }, {
		t([[span, ctx := tracer.Start(ctx, "]]),
		i(1, "name"),
		t([[")]]),
		t({ "", "defer span.End()" }),
	}),

	s({ trig = "vars", dscr = "vars block" }, {
		t({ "var (", "\t" }),
		i(0),
		t({ "", ")" }),
	}),

	s({ trig = "consts", dscr = "consts block" }, {
		t({ "const (", "\t" }),
		i(0),
		t({ "", ")" }),
	}),

	s({ trig = "types", dscr = "types block" }, {
		t({ "type (", "\t" }),
		i(0),
		t({ "", ")" }),
	}),

	-- TODO: Can we make this only possible in a _test.go file?
	s({ trig = "test", dscr = "test func" }, {
		t("func Test"),
		i(1, "Name"),
		t({ "(t *testing.T) {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	s({ trig = "init", dscr = "init func" }, {
		t({ "func init() {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
})
