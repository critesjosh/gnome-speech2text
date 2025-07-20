declare module "gi://Clutter" {
  namespace Clutter {
    interface Actor {
      connect(signal: string, callback: Function): number;
      disconnect(id: number): void;
      show(): void;
      hide(): void;
      destroy(): void;
      add_child(child: Actor): void;
      remove_child(child: Actor): void;
      remove_all_children(): void;
      get_parent(): Actor | null;
      set_reactive(reactive: boolean): void;
      get_reactive(): boolean;
      grab_key_focus(): void;
      set_x_align(align: ActorAlign): void;
    }

    interface BoxLayout extends Actor {
      new(properties?: any): BoxLayout;
      set_x_align(align: ActorAlign): void;
    }

    const EVENT_STOP: boolean;
    const EVENT_PROPAGATE: boolean;

    // Key constants
    const KEY_Escape: number;
    const KEY_Return: number;
    const KEY_KP_Enter: number;

    enum EventType {
      KEY_PRESS = 0,
      KEY_RELEASE = 1,
      BUTTON_PRESS = 2,
      BUTTON_RELEASE = 3,
      MOTION = 4,
      ENTER = 5,
      LEAVE = 6,
    }

    interface Event {
      type(): EventType;
      get_key_symbol(): number;
      get_key_code(): number;
      get_state(): number;
    }

    enum ActorAlign {
      FILL = 0,
      START = 1,
      CENTER = 2,
      END = 3,
    }

    enum Orientation {
      HORIZONTAL = 0,
      VERTICAL = 1,
    }

    enum ModifierType {
      SHIFT_MASK = 1,
      CONTROL_MASK = 4,
      ALT_MASK = 8,
      SUPER_MASK = 64,
    }

    // Constructor functions
    const BoxLayout: {
      new(properties?: any): BoxLayout;
    };
  }

  export = Clutter;
}