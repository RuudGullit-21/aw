#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру обязательных / уникальных реквизитов элемента
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента
// Если ДляГруппы = Истина, аналогично для группы
// Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры для табличных частей
// Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента = Истина, ДляГруппы = Ложь) Экспорт
	ОбязательныеРеквизиты = Новый Структура();
	ОбязательныеРеквизиты.Вставить("Код", 1);
	ОбязательныеРеквизиты.Вставить("Наименование", 3);	
	Если ДляЭлемента Тогда
		ОбязательныеРеквизиты.Вставить("Назначение", 1);
	КонецЕсли;                                         	
	Возврат ОбязательныеРеквизиты;
КонецФункции

// Функция проверяет, допустимо ли изменение объекта
// Возвращает Истина, если изменения возможны, ложь иначе
// Если изменения доступны частично, возвращает ложь и структуру блокируемых на изменение реквизитов,
Функция ДоступностьИзменения(БлокироватьРеквизиты = Неопределено) Экспорт
	// Для этой ПВХ доступны только признак Право/Настройка и Значение по умолчанию
	БлокироватьРеквизиты = Новый Структура();
	БлокироватьРеквизиты.Вставить("Код", 1);
	БлокироватьРеквизиты.Вставить("Наименование", 1);
	БлокироватьРеквизиты.Вставить("Назначение", 1);
	Возврат Ложь;
КонецФункции

// Проверяет корректность заполнения объекта.
	// Возвращает Истина если все заполнено корректно и Ложь иначе.
	// В случае некорректного заполнения формирует строку описанием возникших ошибок "Ошибки"
	// На вход может быть передана структура ДопРеквизиты с дополнительными реквизитами для проверки
	// может управляться булевыми флагами выполняемых проверок Заполнение, Уникальность
	// (могут быть и другие необязательные)
	// Обычно выполняется универсальным обработчиком, но могут быть добавлены доп. проверки
Функция ПроверитьКорректность(Ошибки="", ДопРеквизиты=Неопределено, Заполнение=Истина, Уникальность=Истина) Экспорт
		Возврат уатПраваИНастройки.уатПроверитьКорректность(ЭтотОбъект, Ошибки, ДопРеквизиты, Заполнение, Уникальность);
КонецФункции
	
// Заполняет ПВХ ПраваИНастройки значениями по умолчанию
// из макета "НастройкиПоУмолчанию"
// Уровень настройки также берется из этого макета, поэтому там все
// элементы должны быть прописаны. Причем если тип значения является
// каким-либо перечислением также необходимо указать значение по
// умолчанию (указанием идентификатора конкретного значения)
// Процедура не использует окружение этого объекта (и его модуля) и может
// быть перенесена в любое место конфигурации
Процедура ИнициализироватьПраваИНастройки() Экспорт
		
		ЧислоОшибок = 0; // счетчик ошибок при загрузке прав и настроек
		ВсеПеречисления = Перечисления.ТипВсеСсылки();	// Описание типов для проверки перечислений
		ВсеСправочники  = Справочники.ТипВсеСсылки();   // Описание типов для проверки значений-справочников
		
		// Получим макет настроек по умолчанию
		ИмяМакета = "НастройкиПоУмолчанию";
		Макет = ПланыВидовХарактеристик.уатПраваИНастройки.ПолучитьМакет(Метаданные.ПланыВидовХарактеристик.уатПраваИНастройки.Макеты[ИмяМакета]);
		Если Макет = Неопределено Тогда
			ТекстНСТР = НСтр("en='Not found the template ""%1"" with the rights and settings of the user by default."
"Rights cannot be loaded. Contact the database administrator.';ru='Не обнаружен макет ""%1"" с правами и настройками пользователя по умолчанию."
"Права не могут быть загружены. Обратитесь к администратору базы данных.'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ИмяМакета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
			Возврат;
		КонецЕсли;
		
		// По всем строкам макета
		Для НомерСтроки = 1 По Макет.ВысотаТаблицы Цикл
			
			// Считаем из макета Имя, Наименование, Код, ФлагЭтоНастройка, Назначение и значение по умолчанию
			// флаги НастройкаКомпании, НастройкаОрганизации, НастройкаПодразделения, НастройкаПользователя
			ИмяЭлемПВХ 				   = СтрЗаменить(СокрЛП(Макет.Область(НомерСтроки, 1).Текст), "ИмяПраво_", "");
			СтрНаименование			   = СокрЛП(Макет.Область(НомерСтроки, 2).Текст);
			СтрКод       			   = СокрЛП(Макет.Область(НомерСтроки, 3).Текст);
			СтрНазначение 			   = ПреобразоватьВНазначениеИзКода(СокрЛП(Макет.Область(НомерСтроки, 4).Текст));
			СтрЭтоНастройка			   = СокрЛП(Макет.Область(НомерСтроки, 5).Текст)= "1";
			СтрПоУмолчанию 			   = СтрЗаменить(СокрЛП(Макет.Область(НомерСтроки ,6).Текст), "ПоУмолчанию_", "");
			СтрНастройкаКомпании 	   = СокрЛП(Макет.Область(НомерСтроки ,7).Текст)= "1";
			СтрНастройкаОрганизации    = СокрЛП(Макет.Область(НомерСтроки ,9).Текст)= "1";
			СтрНастройкаПодразделения  = СокрЛП(Макет.Область(НомерСтроки ,10).Текст)= "1";
			СтрНастройкаПользователя   = СокрЛП(Макет.Область(НомерСтроки ,11).Текст)= "1";
				
		#Если Клиент Тогда
			ТекстНСТР = НСтр("en='Right setting:';ru='Настройка прав:'") + " " + Наименование;
			Состояние (ТекстНСТР);
		#КонецЕсли
				
			// попытаемся найти и получить ссылку на элемент ПВХ
			СсылкаПВХправ = уатПраваИНастройки.уатПолучитьСсылкуПВХПравИНастроек(ИмяЭлемПВХ);
			// проверим что нашли
			Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(СсылкаПВХправ) Тогда 
				ЧислоОшибок = ЧислоОшибок + 1;
				ТекстНСТР = НСтр("en='Error loading rights: in line %1 of the template <%2> specified element is absent in the chart of types of characteristics ""Rights and settings"" (%3)';ru='Ошибка при загрузке прав: в строке %1  макета <%2> указан элемент отсутствующий в ПВХ ""Права и настройки"" (%3)'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, НомерСтроки, ИмяМакета, ИмяЭлемПВХ);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Продолжить; 
			ИначеЕсли СсылкаПВХправ.ЭтоГруппа Тогда
				Если (СсылкаПВХправ.Наименование <> СтрНаименование)
					ИЛИ (СокрЛП(СсылкаПВХправ.Код) <> СтрКод) Тогда
					// Переустановим значения реквизитов в ПВХ согласно значениям в макете
					Сообщение = "";
					ОбъектПВХправ = СсылкаПВХправ.ПолучитьОбъект(); 
					
					Если НЕ ПустаяСтрока(СтрКод) Тогда	
						ОбъектПВХправ.Код =	СтрКод;	
					КонецЕсли;
					ОбъектПВХправ.Наименование 	         = СтрНаименование;
					// попытаемся сохранить изменения реквизитов элемента ПВХ				
					Попытка
						// При обновлении конфигурации возможна ситуация дублирования наименования с предопределенным элементом
						// постараемся ее отработать путем поиска и переименования устаревшего элемента
						СтарыйЭлемент = ПланыВидовХарактеристик.уатПраваИНастройки.НайтиПоНаименованию(СтрНаименование, Истина);
						Если (НЕ СтарыйЭлемент.Пустая()) И (СтарыйЭлемент.Ссылка <> ОбъектПВХправ.Ссылка) Тогда
							СтарыйОбъект = СтарыйЭлемент.ПолучитьОбъект();
							СтарыйОбъект.Наименование = НСтр("en='OBSOLETE';ru='УСТАРЕЛ'") + " " + СтарыйОбъект.Наименование;
							СтарыйОбъект.Записать();
							ТекстНСТР = НСтр("en='It is necessary to check right settings <%1>';ru='Необходима проверка настроек права <%1>'");
							ТекстНСТР = СтрШаблон(ТекстНСТР, СтрНаименование);
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
						КонецЕсли;
						// теперь попробуем записать 
						ОбъектПВХправ.Записать();
						ТекстНСТР = НСтр("en='Updated right <%1>';ru='Обновлено право <%1>'");
						ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
					Исключение
						ТекстНСТР = НСтр("en='Right <%1> for line %2 of template <%3> is not updated."
"Error:';ru='Право <%1> для строки %2 макета <%3> не обновлено."
"Ошибка:'") + " " + ОписаниеОшибки();
						ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
					КонецПопытки;
				КонецЕсли;
				Продолжить; // группа
			КонецЕсли;
			
			// Проведем необходимые преобразования типов полученных значений
			// Получим признак настройки
			СтрЭтоНастройка 		   = Булево(СтрЭтоНастройка);
			СтрНастройкаКомпании 	   = Булево(СтрНастройкаКомпании);
			СтрНастройкаОрганизации    = Булево(СтрНастройкаОрганизации);
			СтрНастройкаПодразделения  = Булево(СтрНастройкаПодразделения);
			СтрНастройкаПользователя   = Булево(СтрНастройкаПользователя);
			
			// Определим назначение
			Попытка		
				СтрНазначение = Перечисления.уатНазначениеПравИНастроек[СтрНазначение];
			Исключение	
				СтрНазначение = Перечисления.уатНазначениеПравИНастроек.Пользователь;
				СтрНастройкаПользователя = Истина;
			КонецПопытки;
			// Определим значение по умолчанию
			ОписаниеТипов =	СсылкаПВХправ.ТипЗначения;	// получим описание доступных типов для текущего права/настройки
			ТипЗнач = ОписаниеТипов.Типы().Получить(0);	// получим первый (и единственный) попавшийся из типов доступных для элемента
			// Сначала постараемся преобразовать к нужному типу, а особые типы (перечисления/справочники) обработаем ниже
			ЗнчПоУмолчанию = ОписаниеТипов.ПривестиЗначение(СтрПоУмолчанию);
			// если тип принадлежит к классу перечислений то...
			Если ВсеПеречисления.СодержитТип(ТипЗнач) Тогда
				// то попробуем получить конкретный элемент перечисления
				Перечисление = Новый (ТипЗнач);
				ИмяПеречисления = Перечисление.Метаданные().Имя;
				Попытка	
					Если ПустаяСтрока(СтрПоУмолчанию) Тогда
						ЗнчПоУмолчанию = Неопределено;
					Иначе
						ЗнчПоУмолчанию = Перечисления[ИмяПеречисления][СтрПоУмолчанию];
					КонецЕсли; 
				Исключение	// заполнили в макете некорректно, установим пустышку и поругаемся
					ЧислоОшибок = ЧислоОшибок + 1;
					
					ТекстНСТР = НСтр("en='Error loading right <%1> in line %2 of template <%3> invalid default value <%4>';ru='Ошибка при загрузке права <%1> в строке %2 макета <%3> некорректное значение по умолчанию <%4>'");
					ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ, НомерСтроки, ИмяМакета, СтрПоУмолчанию);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
					
					ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
				КонецПопытки;
				// если тип принадлежит к справочникам
			ИначеЕсли ВсеСправочники.СодержитТип(ТипЗнач) Тогда
				// то попробуем найти и получить значение справочника-ссылки
				ЗнчПоУмолчанию = СокрЛП(СтрПоУмолчанию);
				Если СтрДлина(ЗнчПоУмолчанию) > 0 Тогда
					СПР = Новый(ТипЗнач);
					СпрМетаданные  = СПР.Метаданные();
					ИмяСправочника = СпрМетаданные.Имя;
					Попытка
						СпрМенеджер = Справочники[ИмяСправочника];
					Исключение
						СпрМенеджер = Неопределено;
					КонецПопытки; 
					// 
					Если СпрМенеджер = Неопределено Тогда
						СпрЭлемент = Неопределено
					Иначе
						Попытка // поиск в предопределенных элементах
							СпрЭлемент = СпрМенеджер[ЗнчПоУмолчанию];
						Исключение
							СпрЭлемент = Неопределено;
						КонецПопытки;
						
						Если СпрЭлемент = Неопределено ИЛИ СпрЭлемент.Пустая() Тогда
							Попытка // попробуем найти по именованию
								СпрЭлемент = СпрМенеджер.НайтиПоНаименованию(ЗнчПоУмолчанию, Истина);
							Исключение
								СпрЭлемент = Неопределено;
							КонецПопытки;
						КонецЕсли;
						Если (СпрЭлемент = Неопределено ИЛИ СпрЭлемент.Пустая()) И (СпрМетаданные.ДлинаКода > 0) Тогда
							Попытка // последняя попытка поиска (по коду)
								Если Найти(ЗнчПоУмолчанию, "/") > 0 Тогда // полный код
									СпрЭлемент = СпрМенеджер.НайтиПоКоду(ЗнчПоУмолчанию, Истина);
								Иначе
									// проверим на тип кода
									ТипКода = Тип(СПР.Метаданные().ТипКода);
									Если ТипКода = Тип("Строка") Тогда
										// если строковый то нужно "подогнать" его длину
										Если СтрДлина(ЗнчПоУмолчанию) > СпрМетаданные.ДлинаКода Тогда
											ЗнчПоУмолчанию = Прав(ЗнчПоУмолчанию, СпрМетаданные.ДлинаКода);
										Иначе
											Пока СтрДлина(ЗнчПоУмолчанию) < СпрМетаданные.ДлинаКода Цикл
												ЗнчПоУмолчанию = "0" + ЗнчПоУмолчанию;	
											КонецЦикла;
										КонецЕсли;
									Иначе // а если тип не строка то преобразуем 
										ЗнчПоУмолчанию=ТипКода.ПривестиЗначение(ЗнчПоУмолчанию);
									КонецЕсли;
									// теперь еще раз попробуем найти элемент
									СпрЭлемент = СпрМенеджер.НайтиПоКоду(ЗнчПоУмолчанию, Ложь);
								КонецЕсли;
							Исключение
								СпрЭлемент = Неопределено;
							КонецПопытки;
						КонецЕсли;			
					КонецЕсли;
					// проверим получилось ли найти элемент по умолчанию
					Если СпрЭлемент=Неопределено ИЛИ СпрЭлемент.Пустая() Тогда
						ТекстНСТР = НСтр("en='Error loading right <%1> in line %2 of template <%3> invalid default value <%4>';ru='Ошибка при загрузке права <%1> в строке %2 макета <%3> некорректное значение по умолчанию <%4>'");
						ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ, НомерСтроки, ИмяМакета, СтрПоУмолчанию);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
						ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
					Иначе
						ЗнчПоУмолчанию = СпрЭлемент.Ссылка;
					КонецЕсли;
				Иначе
					ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
				КонецЕсли;
			КонецЕсли;
			
			
			// Проверим все ли реквизиты в ПВХ установлены как и в макете		
			Если (СсылкаПВХправ.Назначение <> СтрНазначение) 
			 ИЛИ (СсылкаПВХправ.ЭтоНастройка <> СтрЭтоНастройка) 
			 ИЛИ (СсылкаПВХправ.ЗначениеПоУмолчанию <> ЗнчПоУмолчанию)
			 ИЛИ (СсылкаПВХправ.Наименование <> СтрНаименование) 
			 ИЛИ (СокрЛП(СсылкаПВХправ.Код) <> СтрКод)
			 ИЛИ (СсылкаПВХправ.НастройкаКомпании <> СтрНастройкаКомпании)
			 ИЛИ (СсылкаПВХправ.НастройкаОрганизации <> СтрНастройкаОрганизации)
			 ИЛИ (СсылкаПВХправ.НастройкаПодразделения <> СтрНастройкаПодразделения)
			 ИЛИ (СсылкаПВХправ.НастройкаПользователя <> СтрНастройкаПользователя) Тогда
				// Переустановим значения реквизитов в ПВХ согласно значениям в макете
				Сообщение = "";
				ОбъектПВХправ = СсылкаПВХправ.ПолучитьОбъект(); 
				
				Если НЕ ПустаяСтрока(СтрКод) Тогда	
					ОбъектПВХправ.Код =	СтрКод;	
				КонецЕсли;
				ОбъектПВХправ.Наименование 	         = СтрНаименование;
				ОбъектПВХправ.Назначение 	         = СтрНазначение;
				ОбъектПВХправ.ЭтоНастройка 	         = СтрЭтоНастройка;
				ОбъектПВХправ.ЗначениеПоУмолчанию    = ЗнчПоУмолчанию;
				ОбъектПВХправ.НастройкаКомпании      = СтрНастройкаКомпании;
				ОбъектПВХправ.НастройкаОрганизации   = СтрНастройкаОрганизации;
				ОбъектПВХправ.НастройкаПодразделения = СтрНастройкаПодразделения;
				ОбъектПВХправ.НастройкаПользователя  = СтрНастройкаПользователя;
				
				// попытаемся сохранить изменения реквизитов элемента ПВХ				
				Попытка
					// При обновлении конфигурации возможна ситуация дублирования наименования с предопределенным элементом
					// постараемся ее отработать путем поиска и переименования устаревшего элемента
					СтарыйЭлемент = ПланыВидовХарактеристик.уатПраваИНастройки.НайтиПоНаименованию(СтрНаименование, Истина);
					Если (НЕ СтарыйЭлемент.Пустая()) И (СтарыйЭлемент.Ссылка <> ОбъектПВХправ.Ссылка) Тогда
						СтарыйОбъект = СтарыйЭлемент.ПолучитьОбъект();
						СтарыйОбъект.Наименование = НСтр("en='OBSOLETE';ru='УСТАРЕЛ'") + " " + СтарыйОбъект.Наименование;
						СтарыйОбъект.Записать();
						ТекстНСТР = НСтр("en='It is necessary to check right settings <%1>';ru='Необходима проверка настроек права <%1>'");
						ТекстНСТР = СтрШаблон(ТекстНСТР, СтрНаименование);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
					КонецЕсли;
					// теперь попробуем записать 
					ОбъектПВХправ.Записать();
					ТекстНСТР = НСтр("en='Updated right <%1>';ru='Обновлено право <%1>'");
					ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Исключение
					ТекстНСТР = НСтр("en='Right <%1> for line %2 of template <%3> is not updated."
"Error:';ru='Право <%1> для строки %2 макета <%3> не обновлено."
"Ошибка:'") + " " + ОписаниеОшибки();
					ТекстНСТР = СтрШаблон(ТекстНСТР, СсылкаПВХправ);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				КонецПопытки;
			КонецЕсли;
			
		КонецЦикла; // по строкам макета
КонецПроцедуры

// Процедура проверяет существование правил доступа для каждого вида объекта справочников и документов.
// В случае, если значение по умолчанию не найдено, создает новое.
// В случае, если справочник отсутствует (удалили), то помечает на удаление элемент ПВХ, а записи
//	регистра прав доступа удаляет.
Процедура ПроверитьПраваДоступа() Экспорт
	
	// Права доступа проверяются только в центральной ИБ
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если Клиент Тогда
		ТекстНСТР = НСтр("en='Checking of access setting rules ...';ru='Проверка правил настройки доступа ...'");
		Состояние(ТекстНСТР);
	#КонецЕсли
	
	Менеджер = ПланыВидовХарактеристик.уатПраваИНастройки;
	
	ГруппаРодительСправочники = Менеджер.ПраваДоступаСправочников.Ссылка;
	Выборка = Менеджер.Выбрать(ГруппаРодительСправочники);
	СправочникиЗаполнены = Выборка.Следующий();
	ПрефиксКода = Лев(ГруппаРодительСправочники.Код, 2);
	
	СтараяГруппа = ГруппаРодительСправочники;
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПраваИНастройки.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.уатПраваИНастройки КАК ПраваИНастройки
	|ГДЕ
	|	ПраваИНастройки.ЭтоГруппа = &Истина
	|	И ПраваИНастройки.Родитель = &Родитель
	|	И ПраваИНастройки.Предопределенный = &Ложь
	|	И ПраваИНастройки.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Истина",       Истина);
	Запрос.УстановитьПараметр("Ложь",         Ложь);
	Запрос.УстановитьПараметр("Родитель",     Менеджер.Справочники.Ссылка);
	Запрос.УстановитьПараметр("Наименование", НСтр("en='ACCESS RIGHTS OF CATALOGS';ru='ПРАВА ДОСТУПА СПРАВОЧНИКОВ'"));
	
	РезЗапроса = Запрос.Выполнить();
	Если НЕ РезЗапроса.Пустой() Тогда
		Выборка = РезЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			СтараяГруппа = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ СправочникиЗаполнены Тогда
		Выборка = Менеджер.Выбрать(СтараяГруппа);
		СправочникиЗаполнены = Выборка.Следующий();
	КонецЕсли;
	ИскатьСтарые = ?(ГруппаРодительСправочники = СтараяГруппа, Ложь, Истина);
	
	Для Каждого ТекСтрока Из Метаданные.Справочники Цикл
		Если ТекСтрока = Неопределено Тогда Продолжить; КонецЕсли;
		
		Имя = ТекСтрока.Имя;
		Поз = Найти(Имя, "уат");
		Если НЕ Поз = 1  Тогда Продолжить; КонецЕсли;
		
		ВидыПравДляСправочников = Перечисления.уатВидыПравДляСправочников.Редактирование; 
		
		МенеджерЗаписи = ПланыВидовХарактеристик.уатПраваИНастройки;
		
		ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Access right';ru='Право доступа'") + " " + Имя, Истина, ГруппаРодительСправочники);
		флагПереключениеЯзыкаЛокализации = Ложь;
		Если ТекСсылка.Пустая() Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Право доступа';ru='Access right'") + " " + Имя, Истина, ГруппаРодительСправочники);
			флагПереключениеЯзыкаЛокализации = Истина;
		КонецЕсли;
		Если ТекСсылка.Пустая() и ИскатьСтарые Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Access right';ru='Право доступа'") + " " + Имя, Истина, СтараяГруппа);
			Если ТекСсылка.Пустая() Тогда
				ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Право доступа';ru='Access right'") + " " + Имя, Истина, СтараяГруппа);
				флагПереключениеЯзыкаЛокализации = Истина;
			КонецЕсли;
		КонецЕсли;
		
		ЕстьИзменения = Ложь;
		Если ТекСсылка.Пустая() Тогда
			МассивТипов = Новый Массив(1);
			МассивТипов[0] = ТипЗнч(ВидыПравДляСправочников);
			
			ТекОбъект = МенеджерЗаписи.СоздатьЭлемент();
			ТекОбъект.Наименование = НСтр("en='Access right';ru='Право доступа'") + " " + Имя;
			ТекОбъект.ТипЗначения  = Новый ОписаниеТипов(МассивТипов);
			ТекОбъект.Назначение   = Перечисления.уатНазначениеПравИНастроек.Пользователь;
			ТекОбъект.НастройкаПользователя = Истина;
			ТекОбъект.ЭтоНастройка = Ложь;
			
			ЕстьИзменения = Истина;
			
		Иначе
			ТекОбъект = ТекСсылка.ПолучитьОбъект();
			
			Если флагПереключениеЯзыкаЛокализации Тогда
				ТекОбъект.Наименование = НСтр("en='Access right';ru='Право доступа'") + " " + Имя;
				ЕстьИзменения = Истина;
			КонецЕсли;
		
			Если НЕ ТекОбъект.НастройкаПользователя Тогда
				ТекОбъект.НастройкаПользователя = Истина;
				ТекОбъект.Наименование = НСтр("en='Access right';ru='Право доступа'") + " " + Имя;
				ЕстьИзменения = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекОбъект.Родитель <> ГруппаРодительСправочники 
		 ИЛИ ТекОбъект.ЗначениеПоУмолчанию <> ВидыПравДляСправочников Тогда
			ТекОбъект.Родитель            = ГруппаРодительСправочники;
			ТекОбъект.ЗначениеПоУмолчанию = ВидыПравДляСправочников;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если Лев(ТекОбъект.Код, 2) <> ПрефиксКода Тогда
			ТекОбъект.УстановитьНовыйКод(ПрефиксКода);
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекОбъект.Записать();
		КонецЕсли;
		
		Если ТекОбъект.ЭтоНовый() и СправочникиЗаполнены Тогда
			ТекстНСТР = НСтр("en='ATTENTION! A new object, included in the exchange plan, is discovered!"
"It is necessary to edit the access setting"
"for the kind of objects: ""%1""!';ru='ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!"
"Необходимо отредактировать настройку доступа "
"для вида объектов: ""%1""!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрока.Представление());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		КонецЕсли;
	КонецЦикла;	
	
	// Удалим старую группу, созданную программно
	Если ИскатьСтарые и НЕ СтараяГруппа.Пустая() Тогда
		Попытка
			СтараяГруппа.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
			ТекстНСТР = НСтр("en='ATTENTION! A check mark for deletion an unused group is set: ""%1"""
"of chart of characteristics ""Rights and settings""!"
"Delete the marked items!';ru='ВНИМАНИЕ! Установлена пометка удаления не используемой группы: ""%1"""
"плана видов характеристик ""Права и настройки""!"
"Произведите удаление помеченных объектов!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, СтараяГруппа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		Исключение КонецПопытки;
	КонецЕсли;
	
	// Теперь заполним префиксацию по умолчанию для документов
	ГруппаРодительДокументы = Менеджер.ПраваДоступаДокументов.Ссылка;
	Выборка = Менеджер.Выбрать(ГруппаРодительДокументы);
	ДокументыЗаполнены = Выборка.Следующий();
	ПрефиксКода = Лев(ГруппаРодительДокументы.Код, 2);
	
	СтараяГруппа = ГруппаРодительДокументы;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПраваИНастройки.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.уатПраваИНастройки КАК ПраваИНастройки
	|ГДЕ
	|	ПраваИНастройки.ЭтоГруппа = &Истина
	|	И ПраваИНастройки.Родитель = &Родитель
	|	И ПраваИНастройки.Предопределенный = &Ложь
	|	И ПраваИНастройки.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Истина",       Истина);
	Запрос.УстановитьПараметр("Ложь",         Ложь);
	Запрос.УстановитьПараметр("Родитель",     Менеджер.Документы.Ссылка);
	Запрос.УстановитьПараметр("Наименование", НСтр("en='ACCESS RIGHTS OF DOCUMENTS';ru='ПРАВА ДОСТУПА ДОКУМЕНТОВ'"));
	
	РезЗапроса = Запрос.Выполнить();
	Если НЕ РезЗапроса.Пустой() Тогда
		Выборка = РезЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			СтараяГруппа = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДокументыЗаполнены Тогда
		Выборка = Менеджер.Выбрать(СтараяГруппа);
		ДокументыЗаполнены = Выборка.Следующий();
	КонецЕсли;
	ИскатьСтарые = ?(ГруппаРодительДокументы = СтараяГруппа, Ложь, Истина);
	
	Для Каждого ТекСтрока Из Метаданные.Документы Цикл
		Если ТекСтрока = Неопределено Тогда Продолжить; КонецЕсли;
		
		Имя = ТекСтрока.Имя;
		Поз = Найти(Имя, "уат");
		Если НЕ Поз = 1  Тогда Продолжить; КонецЕсли;
		ВидыПравДляДокументов = Перечисления.уатВидыПравДляДокументов.РедактированиеВсе;
		
		МенеджерЗаписи = ПланыВидовХарактеристик.уатПраваИНастройки;
		
		ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Access right';ru='Право доступа'") + " " + Имя, Истина, ГруппаРодительДокументы);
		флагПереключениеЯзыкаЛокализации = Ложь;
		Если ТекСсылка.Пустая() Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Право доступа';ru='Access right'") + " " + Имя, Истина, ГруппаРодительДокументы);
			флагПереключениеЯзыкаЛокализации = Истина;
		КонецЕсли;
		Если ТекСсылка.Пустая() и ИскатьСтарые Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Access right';ru='Право доступа'") + " " + Имя, Истина, СтараяГруппа);
			Если ТекСсылка.Пустая() Тогда
				ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию(НСтр("en='Право доступа';ru='Access right'") + " " + Имя, Истина, СтараяГруппа);
				флагПереключениеЯзыкаЛокализации = Истина;
			КонецЕсли;
		КонецЕсли;
		
		ЕстьИзменения = Ложь;
		Если ТекСсылка.Пустая() Тогда
			МассивТипов = Новый Массив(1);
			МассивТипов[0] = ТипЗнч(ВидыПравДляДокументов);
			
			ТекОбъект = МенеджерЗаписи.СоздатьЭлемент();
			ТекОбъект.Наименование = НСтр("en='Access right';ru='Право доступа'") + " " + Имя;
			ТекОбъект.ТипЗначения  = Новый ОписаниеТипов(МассивТипов);
			ТекОбъект.Назначение   = Перечисления.уатНазначениеПравИНастроек.Пользователь;
			ТекОбъект.НастройкаПользователя = Истина;			
			ТекОбъект.ЭтоНастройка = Ложь;
			
			ЕстьИзменения = Истина;
			
		Иначе
			ТекОбъект = ТекСсылка.ПолучитьОбъект();
			
			Если флагПереключениеЯзыкаЛокализации Тогда
				ТекОбъект.Наименование = НСтр("en='Access right';ru='Право доступа'") + " " + Имя;
				ЕстьИзменения = Истина;
			КонецЕсли;

			Если НЕ ТекОбъект.НастройкаПользователя Тогда
				ТекОбъект.НастройкаПользователя = Истина;						
				ЕстьИзменения = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекОбъект.Родитель <> ГруппаРодительДокументы 
		 ИЛИ ТекОбъект.ЗначениеПоУмолчанию <> ВидыПравДляДокументов Тогда
			ТекОбъект.Родитель            = ГруппаРодительДокументы;
			ТекОбъект.ЗначениеПоУмолчанию = ВидыПравДляДокументов;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если Лев(ТекОбъект.Код, 2) <> ПрефиксКода Тогда
			ТекОбъект.УстановитьНовыйКод(ПрефиксКода);
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекОбъект.Записать();
		КонецЕсли;
		
		Если ТекОбъект.ЭтоНовый() и ДокументыЗаполнены Тогда
			ТекстНСТР = НСтр("en='ATTENTION! A new object, included in the exchange plan, is discovered!"
"It is necessary to edit the access setting"
"for the kind of objects: ""%1""!';ru='ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!"
"Необходимо отредактировать настройку доступа"
"для вида объектов: ""%1""!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрока.Представление());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		КонецЕсли;
	КонецЦикла;
	
	// Удалим старую группу, созданную программно
	Если ИскатьСтарые и НЕ СтараяГруппа.Пустая() Тогда
		Попытка
			СтараяГруппа.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
			ТекстНСТР = НСтр("en='ATTENTION! A check mark for deletion an unused group is set: ""%1"""
"of chart of characteristics ""Rights and settings""!"
"Delete the marked items!';ru='ВНИМАНИЕ! Установлена пометка удаления не используемой группы: ""%1"""
"плана видов характеристик ""Права и настройки""!"
"Произведите удаление помеченных объектов!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, СтараяГруппа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		Исключение КонецПопытки;
	КонецЕсли;
	
	Если НЕ СправочникиЗаполнены Тогда
		ТекстНСТР = НСтр("en='ATTENTION! Produced primary filling rules of access settings of catalogs!';ru='ВНИМАНИЕ! Произведено первичное заполнение правил настройки доступа справочников!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
	КонецЕсли;
	Если НЕ ДокументыЗаполнены Тогда
		ТекстНСТР = НСтр("en='ATTENTION! The rules for document access settings are initialized!';ru='ВНИМАНИЕ! Произведено первичное заполнение правил настройки доступа документов!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
	КонецЕсли;
	
	// Удаление прав доступа для отсутствующих справочников и документов
	ГруппаРодительСправочники = ПланыВидовХарактеристик.уатПраваИНастройки.ПраваДоступаСправочников;
	ВыборкаПВХСправ = ПланыВидовХарактеристик.уатПраваИНастройки.Выбрать(ГруппаРодительСправочники);
	Пока ВыборкаПВХСправ.Следующий() Цикл
		ИмяСпр = Сред(ВыборкаПВХСправ.Наименование, СтрДлина(НСтр("en='Access right';ru='Право доступа'") + " ")+1);
		Если Метаданные.Справочники.Найти(ИмяСпр) = Неопределено Тогда
			Попытка
				НаборЗап = РегистрыСведений.уатПраваИНастройки.СоздатьНаборЗаписей();
				НаборЗап.Отбор.ПравоНастройка.Установить(ВыборкаПВХСправ.Ссылка);
				НаборЗап.Записать();
				
				Если НЕ ВыборкаПВХСправ.ПометкаУдаления Тогда
					ВыборкаПВХСправ.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
					ТекстНСТР = НСтр("en='Removed right of access non-existent catalog <%1>!';ru='Удалено право доступа несуществующего справочника <%1>!'");
					ТекстНСТР = СтрШаблон(ТекстНСТР, ИмяСпр);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	ГруппаРодительДокументы = ПланыВидовХарактеристик.уатПраваИНастройки.ПраваДоступаДокументов;
	ВыборкаПВХДокум = ПланыВидовХарактеристик.уатПраваИНастройки.Выбрать(ГруппаРодительДокументы);
	Пока ВыборкаПВХДокум.Следующий() Цикл
		ИмяДок = Сред(ВыборкаПВХДокум.Наименование, СтрДлина(НСтр("en='Access right';ru='Право доступа'") + " ")+1);
		Если Метаданные.Документы.Найти(ИмяДок) = Неопределено Тогда
			Попытка
				НаборЗап = РегистрыСведений.уатПраваИНастройки.СоздатьНаборЗаписей();
				НаборЗап.Отбор.ПравоНастройка.Установить(ВыборкаПВХДокум.Ссылка);
				НаборЗап.Записать();
				
				Если НЕ ВыборкаПВХДокум.ПометкаУдаления Тогда
					ВыборкаПВХДокум.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
					ТекстНСТР = НСтр("en='Removed right of access a nonexistent document <%1>!';ru='Удалено право доступа несуществующего документа <%1>!'");
					ТекстНСТР = СтрШаблон(ТекстНСТР, ИмяДок);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Если ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.МедработникВыезд
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.МедработникВозврат
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ВыдалДиспетчер
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ПринялДиспетчер
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ВыпустилМеханик
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ПринялМеханик
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.УполномоченныйНаПроставлениеОдометраПриВыезде
			ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.УполномоченныйНаПроставлениеОдометраПриВозврате Тогда
			Возврат;
		КонецЕсли;
		
		Если ПометкаУдаления Тогда 
			Возврат;
		КонецЕсли;
		
		// Проверим ограничение по типам, т.к. поддерживается строго один тип для каждого элемента
		Если (ЭтотОбъект.ТипЗначения.Типы().Количество() <> 1) и (НЕ ЭтотОбъект.ЭтоГруппа) Тогда
			Отказ = Истина;
			ТекстНСТР = НСтр("en='Single type of possible values must be specified! Record of element <%1> has been canceled!';ru='Должен быть указан единственный тип возможных значений! Запись элемента <%1> отменена!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, СокрЛП(ЭтотОбъект));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьВНазначениеИзКода(СтрНазначение)
	Если СтрНазначение = "1" Тогда
		СтрНазначение 		   = "Пользователь";
	ИначеЕсли СтрНазначение = "2" Тогда
		СтрНазначение 		   = "Организация";
	ИначеЕсли СтрНазначение = "3" Тогда
		СтрНазначение 		   = "Подразделение";
	КонецЕсли;
Возврат СтрНазначение;
КонецФункции

#КонецОбласти
