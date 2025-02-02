///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если (ОбщегоНазначения.РазделениеВключено())
			// Зашли в конфигурацию под пользователем без разделения (АдминистраторСистемы или фоновое задание (пустой пользователь)).
			И (ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей()) Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	Если Параметры.ТекущийПользователь.Пустая()
			ИЛИ (ПравоДоступа("СохранениеДанныхПользователя", Метаданные) = Ложь) Тогда
		ЭтотОбъект.ТекущийПользователь = Пользователи.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ТекущийПользователь = Параметры.ТекущийПользователь;
	КонецЕсли;

	ЭтотОбъект.ЛентаНовостей = Параметры.ЛентаНовостей;

	ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.Очистить();
	// В поле ОтборыПоЛентамНовостейПользовательские загрузить все доступные для этой ленты новостей пользовательские и глобальные отборы,
	//  а там, где есть хотя бы один пользовательский отбор, включить галочку "ОтбиратьПоКатегории".
	ТаблицаЗначенийОтборов = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаТаблицыЗначенийПользовательскихОтборов);
	ТаблицаЗначенийГлобальныхОтборов = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаТаблицыЗначенийГлобальныхОтборов);
	Для каждого ТекущаяКатегория Из ЭтотОбъект.ЛентаНовостей.ДоступныеКатегорииНовостей Цикл
		// Добавить строку в ТЧ ОтборыПоЛентамНовостейПользовательские, заполнить основные параметры.
		НоваяСтрока = ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.Добавить();
		НоваяСтрока.КатегорияНовостей = ТекущаяКатегория.КатегорияНовостей;
		НоваяСтрока.ЗаполняетсяАвтоматически = ТекущаяКатегория.КатегорияНовостей.ЗаполняетсяАвтоматически;
		НоваяСтрока.РазрешеноНастраиватьПользователям = ТекущаяКатегория.РазрешеноНастраиватьПользователям;

		// Заполнить пользовательские отборы.
		Если ТаблицаЗначенийОтборов.Количество() > 0 Тогда
			НайденнаяСтрока = ТаблицаЗначенийОтборов.Найти(ТекущаяКатегория.КатегорияНовостей, "КатегорияНовостей");
		Иначе
			НайденнаяСтрока = Неопределено;
		КонецЕсли;
		Если (НайденнаяСтрока <> Неопределено)
				И (НоваяСтрока.РазрешеноНастраиватьПользователям = Истина) 
				И (НоваяСтрока.ЗаполняетсяАвтоматически = Ложь) Тогда
			НоваяСтрока.СписокЗначенийОтборов = НайденнаяСтрока.СписокЗначенийОтборов.Скопировать();
		Иначе
			НоваяСтрока.СписокЗначенийОтборов.Очистить();
		КонецЕсли;

		// Заполнить глобальные отборы.
		Если ТаблицаЗначенийГлобальныхОтборов.Количество() > 0 Тогда
			НайденнаяСтрока = ТаблицаЗначенийГлобальныхОтборов.Найти(ТекущаяКатегория.КатегорияНовостей, "КатегорияНовостей");
		Иначе
			НайденнаяСтрока = Неопределено;
		КонецЕсли;
		Если (НайденнаяСтрока <> Неопределено)
				И (НоваяСтрока.ЗаполняетсяАвтоматически = Ложь) Тогда
			НоваяСтрока.СписокЗначенийГлобальныхОтборов = НайденнаяСтрока.СписокЗначенийОтборов.Скопировать();
		Иначе
			НоваяСтрока.СписокЗначенийГлобальныхОтборов.Очистить();
		КонецЕсли;

		// Заполнить поля ОтбиратьПоКатегории и СписокЗначенийОтборовКоличество.
		Если НоваяСтрока.ЗаполняетсяАвтоматически = Истина Тогда
			НоваяСтрока.СписокЗначенийОтборовКоличество = 0; // Для автозаполняемого значения нет доступных отборов.
			НоваяСтрока.ОтбиратьПоКатегории = Ложь;
		Иначе
			Если НоваяСтрока.РазрешеноНастраиватьПользователям = Ложь Тогда
				НоваяСтрока.СписокЗначенийОтборов.Очистить();
				// Если пользователю запрещено настраивать отборы, то количество = 0.
				НоваяСтрока.СписокЗначенийОтборовКоличество = 0;
				НоваяСтрока.ОтбиратьПоКатегории = Ложь;
			Иначе // Разрешено настраивать пользователю.
				Если (НоваяСтрока.СписокЗначенийГлобальныхОтборов.Количество() > 0)
						И (НоваяСтрока.СписокЗначенийОтборов.Количество() > 0) Тогда
					// Есть глобальные отборы - пользователю можно отбирать только по разрешенным значениям.
					БылиУдаления = Истина;
					Пока БылиУдаления = Истина Цикл
						БылиУдаления = Ложь;
						Для каждого ТекущийПользовательскийОтбор Из НоваяСтрока.СписокЗначенийОтборов Цикл
							НайденныйГлобальныйОтбор = НоваяСтрока.СписокЗначенийГлобальныхОтборов.НайтиПоЗначению(ТекущийПользовательскийОтбор.Значение);
							Если НайденныйГлобальныйОтбор = Неопределено Тогда
								БылиУдаления = Истина;
								НоваяСтрока.СписокЗначенийОтборов.Удалить(ТекущийПользовательскийОтбор);
							КонецЕсли;
						КонецЦикла;
					КонецЦикла;
				КонецЕсли;
				// Если пользователю разрешено настраивать отборы, то количество = максимуму из количества
				//  пользовательских и глобальных отборов.
				НоваяСтрока.СписокЗначенийОтборовКоличество = НоваяСтрока.СписокЗначенийОтборов.Количество();
				// Если пользователю запрещено настраивать эту категорию, то надо определить, как администратор новостей настроил отборы:
				// - Если есть хотя бы 1 значение глобального отбора, то включить галочку (и сделать ее недоступной);
				// - Если нет глобального отбора, то выключить галочку (и сделать ее недоступной).
				Если НоваяСтрока.СписокЗначенийОтборовКоличество = 0 Тогда
					НоваяСтрока.ОтбиратьПоКатегории = Ложь;
				Иначе
					НоваяСтрока.ОтбиратьПоКатегории = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Настройка отборов для ленты новостей %1'; en = 'Configure filters for news feed %1'"),
			ЭтотОбъект.ЛентаНовостей);
	Если ЭтотОбъект.ТекущийПользователь <> Пользователи.ТекущийПользователь() Тогда
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (" + ЭтотОбъект.ТекущийПользователь + ")";
	КонецЕсли;

	УстановитьУсловноеОформление();

	ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей();
	ОбновитьНадписиДоступностиОтборовДляКатегорииНовостей();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)

	// Данные для передачи владельцу.
	Результат = ПодготовитьСтруктуруДляВозвратаПоОК();
	ЭтотОбъект.Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура КомандаНастроитьЗначенияОтборов(Команда)

	Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные <> Неопределено Тогда
		Если (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.РазрешеноНастраиватьПользователям = Истина) 
				И (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ЗаполняетсяАвтоматически = Ложь) Тогда

			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("ЛентаНовостей", ЭтотОбъект.ЛентаНовостей);
			ПараметрыОткрытия.Вставить("КатегорияНовостей", Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.КатегорияНовостей);
			ПараметрыОткрытия.Вставить("СписокЗначенийОтборов", Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов);
			ПараметрыОткрытия.Вставить("СписокЗначенийГлобальныхОтборов", Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийГлобальныхОтборов);
			ПараметрыОткрытия.Вставить("ТекущийПользователь", ЭтотОбъект.ТекущийПользователь);

			ОткрытьФорму(
				"ХранилищеНастроек.НастройкиНовостей.Форма.ФормаНастройкиОтборовПоКатегории",
				ПараметрыОткрытия,
				Элементы.ОтборыПоЛентамНовостейПользовательские, // Владелец
				"");

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаОчиститьЗначенияОтборов(Команда)

	Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные <> Неопределено Тогда
		Если (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.РазрешеноНастраиватьПользователям = Истина) 
				И (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ЗаполняетсяАвтоматически = Ложь) Тогда
			// Очистить список значений пользовательских отборов.
			Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов.Очистить();
			// Заполнить реквизит количества значений пользовательских отборов.
			Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборовКоличество =
				Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов.Количество();
			// Установить галочку "ОтбиратьПоКатегории".
			Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ОтбиратьПоКатегории = Ложь;
			// Обновить надписи текущих значений отборов.
			ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей(Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущаяСтрока);
			// Вывести предупреждение об отборах, настроенных администратором.
			Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийГлобальныхОтборов.Количество() > 0 Тогда
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Часть отборов не удалена'; en = 'Some filters not removed'"),
					, // Навигационная ссылка
					НСтр("ru = 'Отборы, настроенные администратором, удалить нельзя.'; en = 'Filters set up by administrator, cannot be removed.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПоЛентамНовостейПользовательскиеОтбиратьПоКатегорииПриИзменении(Элемент)

	Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные <> Неопределено Тогда
		Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ОтбиратьПоКатегории = Ложь Тогда
			// Очистить список значений пользовательских отборов.
			Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов.Очистить();
			// Заполнить реквизит количества значений пользовательских отборов.
			Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборовКоличество =
				Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов.Количество();
		КонецЕсли;
	КонецЕсли;
	ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей(Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущаяСтрока);
	ОбновитьНадписиДоступностиОтборовДляКатегорииНовостей(Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПоЛентамНовостейПользовательскиеПриАктивизацииСтроки(Элемент)

	Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные <> Неопределено Тогда
		Если (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.РазрешеноНастраиватьПользователям = Истина) 
				И (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ЗаполняетсяАвтоматически = Ложь) Тогда
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаНастроитьЗначенияОтборов.Доступность                = Истина;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаОчиститьЗначенияОтборов.Доступность                 = Истина;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаНастроитьЗначенияОтборов.Доступность = Истина;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаОчиститьЗначенияОтборов.Доступность  = Истина;
		Иначе
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаНастроитьЗначенияОтборов.Доступность                = Ложь;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаОчиститьЗначенияОтборов.Доступность                 = Ложь;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаНастроитьЗначенияОтборов.Доступность = Ложь;
			Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаОчиститьЗначенияОтборов.Доступность  = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаНастроитьЗначенияОтборов.Доступность                = Ложь;
		Элементы.ОтборыПоЛентамНовостейПользовательскиеКомандаОчиститьЗначенияОтборов.Доступность                 = Ложь;
		Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаНастроитьЗначенияОтборов.Доступность = Ложь;
		Элементы.ОтборыПоЛентамНовостейПользовательскиеКонтекстноеМенюКомандаОчиститьЗначенияОтборов.Доступность  = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПоЛентамНовостейПользовательскиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ОтборыПоЛентамНовостейПользовательскиеСписокЗначенийОтборовПредставление" Тогда
		СтандартнаяОбработка = Ложь; // Чтобы строка не переходила в режим редактирования.
		КомандаНастроитьЗначенияОтборов(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПоЛентамНовостейПользовательскиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТипСписокЗначений = Тип("СписокЗначений");

	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = ТипСписокЗначений Тогда
		Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные <> Неопределено Тогда
			Если (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ЗаполняетсяАвтоматически = Ложь)
					И (Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.РазрешеноНастраиватьПользователям = Истина) Тогда
				Если ТипЗнч(Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов) = ТипСписокЗначений Тогда
					// Заполнить список значений пользовательских отборов.
					Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов = ВыбранноеЗначение.Скопировать();
					// Заполнить реквизит количества значений пользовательских отборов.
					Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборовКоличество =
						Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборов.Количество();
					// Установить галочку "ОтбиратьПоКатегории".
					Если Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.СписокЗначенийОтборовКоличество = 0 Тогда
						Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ОтбиратьПоКатегории = Ложь;
					Иначе
						Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущиеДанные.ОтбиратьПоКатегории = Истина;
					КонецЕсли;
					// Обновить надписи текущих значений отборов.
					ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей(Элементы.ОтборыПоЛентамНовостейПользовательские.ТекущаяСтрока);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьСтруктуруДляВозвратаПоОК()

	// Из таблицы ОтборыПоЛентамНовостейПользовательские выбрать только те строки, у которых включена галочка "ОтбиратьПоКатегории".
	НайденныеСтроки = ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.НайтиСтроки(Новый Структура("ОтбиратьПоКатегории", Истина));
	ТаблицаЗначенийПользовательскихОтборов = ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.Выгрузить(НайденныеСтроки);

	Результат = Новый Структура("ЛентаНовостей, АдресХранилищаТаблицыЗначенийПользовательскихОтборов",
		ЭтотОбъект.ЛентаНовостей,
		ПоместитьВоВременноеХранилище(ТаблицаЗначенийПользовательскихОтборов));

	Возврат Результат;

КонецФункции

&НаСервере
// Для колонки "СписокЗначенийОтборовПредставление" выводит надпись в зависимости от установленных значений отборов.
//
// Параметры:
//  ИдентификаторСтроки - Число или Неопределено.
//
Процедура ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей(Знач ИдентификаторСтроки = Неопределено)

	ТипСписокЗначений = Тип("СписокЗначений");

	Если ИдентификаторСтроки = Неопределено Тогда
		Для каждого ТекущаяСтрока Из ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские Цикл
			ОбновитьНадписиПредставленияОтборовДляКатегорииНовостей(ТекущаяСтрока.ПолучитьИдентификатор());
		КонецЦикла;
	Иначе
		НайденнаяСтрока = ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если НайденнаяСтрока <> Неопределено Тогда
			НайденнаяСтрока.ЗаполняетсяАвтоматически = НайденнаяСтрока.КатегорияНовостей.ЗаполняетсяАвтоматически;
			Если НайденнаяСтрока.ЗаполняетсяАвтоматически Тогда
				Значение = ОбработкаНовостейПовтИсп.ПолучитьЗначениеПредопределеннойКатегории(НайденнаяСтрока.КатегорияНовостей);
				Если ТипЗнч(Значение) = ТипСписокЗначений Тогда
					Если Значение.Количество() >= 1 Тогда
						Представление = Значение[Значение.Количество()-1].Значение;
					Иначе
						Представление = "";
					КонецЕсли;
				Иначе
					Представление = Значение;
				КонецЕсли;
				НайденнаяСтрока.СписокЗначенийОтборовПредставление = "" + Представление;
			Иначе // НЕ заполняется автоматически
				Если НайденнаяСтрока.РазрешеноНастраиватьПользователям = Истина Тогда
					// Пользователю разрешено менять значения отборов.
					// Значения в списке СписокЗначенийОтборов должны входить в подмножество СписокЗначенийГлобальныхОтборов.
					// Это контролируется на этапе создания этой формы и в процессе редактирования СпискаЗначений пользовательских отборов.
					// Если пользователь не ввел ни одного значения, то отбор = отбору, настроенному администратором.
					Если (НайденнаяСтрока.СписокЗначенийОтборов.Количество() = 0) Тогда
						Если (НайденнаяСтрока.СписокЗначенийГлобальныхОтборов.Количество() = 0) Тогда
							Если НайденнаяСтрока.ОтбиратьПоКатегории Тогда
								НайденнаяСтрока.СписокЗначенийОтборовПредставление = НСтр("ru = 'Введите значения отборов'; en = 'Input selections values'");
							Иначе
								НайденнаяСтрока.СписокЗначенийОтборовПредставление = ""; // Вывести все значения
							КонецЕсли;
						Иначе
							НайденнаяСтрока.СписокЗначенийОтборовПредставление = НСтр("ru = 'Настроено администратором:'; en = 'Configured by the administrator:'") + " ";
							Для каждого ТекущееЗначениеОтбора Из НайденнаяСтрока.СписокЗначенийГлобальныхОтборов Цикл
								НайденнаяСтрока.СписокЗначенийОтборовПредставление = НайденнаяСтрока.СписокЗначенийОтборовПредставление + Строка(ТекущееЗначениеОтбора.Значение) + "; ";
							КонецЦикла;
						КонецЕсли;
					Иначе
						НайденнаяСтрока.СписокЗначенийОтборовПредставление = "";
						Для каждого ТекущееЗначениеОтбора Из НайденнаяСтрока.СписокЗначенийОтборов Цикл
							НайденнаяСтрока.СписокЗначенийОтборовПредставление = НайденнаяСтрока.СписокЗначенийОтборовПредставление + Строка(ТекущееЗначениеОтбора.Значение) + "; ";
						КонецЦикла;
					КонецЕсли;
				Иначе
					// Пользователю запрещено менять значения отборов.
					// Администратор сам настроил отбор, или надо получать все новости?
					Если НайденнаяСтрока.СписокЗначенийГлобальныхОтборов.Количество() > 0 Тогда
						// Администратор настраивал отбор на несколько значений, и настроил запрет на настройку отборов.
						НайденнаяСтрока.СписокЗначенийОтборовПредставление = Строка(НайденнаяСтрока.СписокЗначенийГлобальныхОтборов);
					Иначе
						// Администратор НЕ настраивал отбор, но настроил запрет на настройку отборов
						//   пользователем - значит, просто получать все новости.
						НайденнаяСтрока.СписокЗначенийОтборовПредставление = ""; // Получать все новости
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
// Для колонки "ПредставлениеДоступностиОтбора" выводит надпись в зависимости от установленных разрешений отборов.
//
// Параметры:
//  ИдентификаторСтроки - Число или Неопределено.
//
Процедура ОбновитьНадписиДоступностиОтборовДляКатегорииНовостей(Знач ИдентификаторСтроки = Неопределено)

	Если ИдентификаторСтроки = Неопределено Тогда
		Для каждого ТекущаяСтрока Из ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские Цикл
			ОбновитьНадписиДоступностиОтборовДляКатегорииНовостей(ТекущаяСтрока.ПолучитьИдентификатор());
		КонецЦикла;
	Иначе
		НайденнаяСтрока = ЭтотОбъект.ОтборыПоЛентамНовостейПользовательские.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если НайденнаяСтрока <> Неопределено Тогда
			Если (НайденнаяСтрока.ЗаполняетсяАвтоматически = Истина) Тогда
				НайденнаяСтрока.ПредставлениеДоступностиОтбора = НСтр("ru = 'Заполняется автоматически, настройка запрещена'; en = 'Filled in automatically, setting is prohibited'");
			Иначе
				Если (НайденнаяСтрока.РазрешеноНастраиватьПользователям = Истина) Тогда
					Если НайденнаяСтрока.ОтбиратьПоКатегории = Истина Тогда
						НайденнаяСтрока.ПредставлениеДоступностиОтбора = НСтр("ru = 'Я хочу настроить отбор'; en = 'I want to set filter'");
					Иначе
						НайденнаяСтрока.ПредставлениеДоступностиОтбора = НСтр("ru = 'Показывать все новости по этой категории'; en = 'Show all news of this category'");
					КонецЕсли;
				Иначе
					Если НайденнаяСтрока.СписокЗначенийГлобальныхОтборов.Количество() > 0 Тогда
						// Если администратор ввел свои значения отбора и запретил редактировать.
						НайденнаяСтрока.ПредставлениеДоступностиОтбора = НСтр("ru = 'Отбор уже настроен администратором, настройка запрещена'; en = 'Filter is already set up by administrator, setting is prohibited'");
					Иначе
						// Если администратор просто запретил редактировать, не вводя доп.ограничений - будут получены все новости.
						НайденнаяСтрока.ПредставлениеДоступностиОтбора = НСтр("ru = 'Эта настройка отбора запрещена администратором'; en = 'This filter setting is prohibited by administrator'");
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Если отбор не включен пользователем, то выделить отбор цветом.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеСписокЗначенийОтборовПредставление.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.ОтбиратьПоКатегории");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.РазрешеноНастраиватьПользователям");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

	// 2. Если отбор отключен администратором или заполняется автоматически,
	//   то текст представления отбора вывести серым цветом и запретить редактирование.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеПредставлениеДоступностиОтбора.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеОтбиратьПоКатегории.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеСписокЗначенийОтборовПредставление.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.РазрешеноНастраиватьПользователям");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

		// Использование
		Элемент.Использование = Истина;

	// 3. Нельзя настроить пользователю - убрать поле выбора пометки,
	//    показать надпись ПредставлениеДоступности.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеОтбиратьПоКатегории.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.РазрешеноНастраиватьПользователям");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

		// Использование
		Элемент.Использование = Истина;

	// 4. Можно настроить пользователю - показать поле выбора, убрать надпись ПредставлениеДоступности.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборыПоЛентамНовостейПользовательскиеПредставлениеДоступностиОтбора.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборыПоЛентамНовостейПользовательские.РазрешеноНастраиватьПользователям");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти
