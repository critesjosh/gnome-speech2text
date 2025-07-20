export interface ExtensionMetadata {
  uuid: string;
  name: string;
  description: string;
  version: number;
  'shell-version': string[];
  url?: string;
  'settings-schema'?: string;
  'gettext-domain'?: string;
  path: string;
}

export abstract class Extension {
  metadata: ExtensionMetadata;
  
  constructor(metadata: ExtensionMetadata) {
    this.metadata = metadata;
  }
  
  abstract enable(): void;
  abstract disable(): void;
  
  getSettings(): any {
    // Implementation would be provided by GNOME Shell
    return null;
  }
}

export interface RecordingState {
  isRecording: boolean;
  isProcessing: boolean;
  recordingProcess: any | null;
  startTime?: number;
  duration?: number;
}

export interface ExtensionSettings {
  'recording-duration': number;
  'keyboard-shortcut': string[];
  'copy-to-clipboard': boolean;
  'skip-preview': boolean;
}

export interface ProcessResult {
  success: boolean;
  stdout?: string;
  stderr?: string;
  exitCode?: number;
}

export interface SetupStatus {
  isSetup: boolean;
  pythonPath?: string;
  venvPath?: string;
  error?: string;
}