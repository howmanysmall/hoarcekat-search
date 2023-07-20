local ReductionUtility = require(script.Parent.Parent.Parent.Parent.Vendor.ReductionUtility)

local DEFAULT_ALPHA = 0.2

local Reduction = {}

Reduction.SetAlpha = ReductionUtility.MakeActionCreator("SetAlpha", function(alpha: number)
	return {
		Value = alpha;
	}
end)

Reduction.SetDragging = ReductionUtility.MakeActionCreator("SetDragging", function(dragging: boolean)
	return {
		Value = dragging;
	}
end)

Reduction.SetHovering = ReductionUtility.MakeActionCreator("SetHovering", function(hovering: boolean)
	return {
		Value = hovering;
	}
end)

export type IState = {
	Alpha: number,
	Dragging: boolean,
	Hovering: boolean,
}

local INITIAL_STATE: IState = table.freeze({
	Alpha = DEFAULT_ALPHA;
	Dragging = false;
	Hovering = false;
})
Reduction.InitialState = INITIAL_STATE

Reduction.Reducer = ReductionUtility.CreateReducer(INITIAL_STATE, {
	[Reduction.SetAlpha.name] = function(state: IState, action: {Value: number})
		local new = table.clone(state)
		new.Alpha = action.Value
		return table.freeze(new)
	end;

	[Reduction.SetDragging.name] = function(state: IState, action: {Value: boolean})
		local new = table.clone(state)
		new.Dragging = action.Value
		return table.freeze(new)
	end;

	[Reduction.SetHovering.name] = function(state: IState, action: {Value: boolean})
		local new = table.clone(state)
		new.Hovering = action.Value
		return table.freeze(new)
	end;
})

return table.freeze(Reduction)
