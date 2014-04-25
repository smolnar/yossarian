Yossarian.ArrayTransform = DS.Transform.extend
  deserialize: (serialized) -> if Em.none(serialized) then [] else serialized
  serialize:   (deserialized) -> if Em.none(deserialized) then [] else deserialized
