
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;

	Элементы.Автопарк.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.Автопарк) Тогда
		Элементы.Автопарк.СписокВыбора.Добавить(Объект.IDАвтопарка, Объект.Автопарк);
	КонецЕсли;

	Элементы.Компания.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.Компания) Тогда
		Элементы.Компания.СписокВыбора.Добавить(Объект.IDКомпании, Объект.Компания);
	КонецЕсли;

	ЗагружатьКарточкуШтрафа = Объект.ЗагружатьКарточкуШтрафа;
	ЗагружатьФото           = Объект.ЗагружатьФото;
	Элементы.ФормаЛогированиеЗапросов.Пометка = Объект.ЛогированиеЗапросов;

	УстановитьСвязиПараметровВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.ЗагружатьКарточкуШтрафа = ЗагружатьКарточкуШтрафа;
	Объект.ЗагружатьФото           = ЗагружатьФото;

	Если Объект.Версия = ПредопределенноеЗначение("Перечисление.уатВерсииШтрафовНет.ШтрафовНет_3")
		И ЗначениеЗаполнено(Объект.IDКомпании) Тогда
		
		ТекстНСТР = НСтр("ru = 'Загрузка штрафов с незаполненным ТС возможна только для 1 учетной записи, чтоб избежать дублирования загруженных данных.'");
		флагЕстьУчетки = Ложь;
		Если Объект.ШтрафСвязанСКомпанией Тогда
			ДругаяУчетка = ПолучитьДругуюОсновнуюУчеткуШтрафовСвязаннуюСКомпанией(Объект.Ссылка, Объект.IDКомпании, Объект.АдресСервиса);
			Если ЗначениеЗаполнено(ДругаяУчетка) Тогда
				Отказ = Истина;
				
				ТекстНСТР = ТекстНСТР + Символы.ПС
					+ НСтр("ru = 'Уже имеется учетная запись ""%1"" с включенной настройкой ""Принадлежность штрафов: Владелец (компания)""!'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ДругаяУчетка);
				Объект.ШтрафСвязанСКомпанией = Ложь;
				флагЕстьУчетки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если Объект.ШтрафСвязанСВодителем Тогда
			ДругаяУчетка = ПолучитьДругуюОсновнуюУчеткуШтрафовСвязаннуюСВодителем(Объект.Ссылка, Объект.IDКомпании, Объект.АдресСервиса);
			Если ЗначениеЗаполнено(ДругаяУчетка) Тогда
				Отказ = Истина;
				ТекстНСТР = ТекстНСТР + Символы.ПС
					+ НСтр("ru = 'Уже имеется учетная запись ""%1"" с включенной настройкой ""Принадлежность штрафов: Водитель""!'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ДругаяУчетка);
				Объект.ШтрафСвязанСВодителем = Ложь;
				флагЕстьУчетки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если флагЕстьУчетки Тогда
			ПоказатьПредупреждение(Неопределено, ТекстНСТР);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВнешняяСистемаПриИзменении(Элемент)
	Если Объект.ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ШтрафовНет") Тогда
		Элементы.АдресСервиса.ПодсказкаВвода = "https://api.shtrafovnet.ru/latest/clients";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВнешняяСистемаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Отбор = Новый Структура("ТипВнешнейСистемы", ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СервисШтрафов"));
	ОткрытьФорму("Справочник.уатВнешниеСистемы.Форма.ФормаВыбора", Новый Структура("Отбор", Отбор), Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АвтопаркНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.ТокенАвторизации) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо получить токен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ТокенАвторизации");
		Возврат;
	КонецЕсли;
	
	Если Объект.Версия = ПредопределенноеЗначение("Перечисление.уатВерсииШтрафовНет.ШтрафовНет_3")
		И НЕ ЗначениеЗаполнено(Объект.IDКомпании) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо получить идентификатор компании.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.Компания");
		Возврат;
	КонецЕсли;

	ШтрафовНет_ПолучитьСписокАвтопарков();
КонецПроцедуры

&НаКлиенте
Процедура КомпанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.ТокенАвторизации) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо получить токен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ТокенАвторизации");
		Возврат;
	КонецЕсли;
	ШтрафовНет_ПолучитьСписокКомпаний();
КонецПроцедуры

&НаКлиенте
Процедура АвтопаркОчистка(Элемент, СтандартнаяОбработка)
	Объект.IDАвтопарка = "";
	Объект.Автопарк    = "";
КонецПроцедуры

&НаКлиенте
Процедура КомпанияОчистка(Элемент, СтандартнаяОбработка)
	Объект.IDКомпании = "";
	Объект.Компания   = "";
КонецПроцедуры

&НаКлиенте
Процедура АвтопаркОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Автопарк = Элементы.Автопарк.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура КомпанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Компания = Элементы.Компания.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ВерсияПриИзменении(Элемент)
	Объект.АдресСервиса = "";
	Объект.ШтрафСвязанСМашиной = Истина;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаПроездовПоЦКАДвОтчетыСистемыАвтодорПриИзменении(Элемент)
	Объект.Контрагент			 = Неопределено;
	Объект.ДоговорКонтрагента	 = Неопределено;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Если Объект.Организация = ОрганизацияПередИзменением Тогда
		Возврат;
	КонецЕсли;
	ОрганизацияПередИзменением = Объект.Организация;
	
	ПриИзмененииКонтрагентаИлиОрганизации();

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент) 
	КонтрагентПередИзменением = Контрагент;
	Контрагент = Объект.Контрагент;
	
	Если КонтрагентПередИзменением <> Объект.Контрагент Тогда
		ПриИзмененииКонтрагентаИлиОрганизации();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	Если Объект.ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ШтрафовНет") Тогда
		ПроверитьПодключениеШтрафовНет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТокен(Команда)
	Если ПустаяСтрока(Объект.АдресСервиса) Тогда 
		ТекстОшибки = НСтр("ru = 'Необходимо заполнить адрес сервиса'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.АдресСервиса");
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
	"Справочник.уатУчетныеЗаписиСервисовШтрафов.Форма.ФормаАвторизации",
	Новый Структура("АдресСервиса, Версия", Объект.АдресСервиса, Объект.Версия),
	ЭтотОбъект,
	,
	,
	,
	Новый ОписаниеОповещения("ПолучитьТокенЗавершение", ЭтотОбъект),
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАдресПоУмолчанию(Команда)
	Объект.АдресСервиса = СтрЗаменить(СтрЗаменить(Элементы.АдресСервиса.ПодсказкаВвода, "Например:", ""), " ", "");
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПроксиСервера(Команда)
	
	ПараметрыФормы = Неопределено;
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		ПараметрыФормы = Новый Структура("НастройкаПроксиНаКлиенте", Истина);
	КонецЕсли;
	
	ПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера(ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ЛогированиеЗапросов(Команда)
	Элементы.ФормаЛогированиеЗапросов.Пометка = НЕ Элементы.ФормаЛогированиеЗапросов.Пометка;
	Объект.ЛогированиеЗапросов                = НЕ Объект.ЛогированиеЗапросов;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьТокенЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ТокенАвторизации = Результат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеШтрафовНет()
	
	
	ОшибкаЗаполнения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.АдресСервиса) Тогда 
		ТекстОшибки = НСтр("en='It is necessary to specify address of service штрафов.';ru='Необходимо указать адрес сервиса штрафов.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.АдресСервиса",, ОшибкаЗаполнения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ТокенАвторизации) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо получить токен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ТокенАвторизации",, ОшибкаЗаполнения);
	КонецЕсли;
	
	Если ОшибкаЗаполнения Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ПодключениеКШтрафовНетДоступно() Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждение = НСтр("en='Connection check is completed successfully.';ru='Проверка подключения успешно завершена.'");
	ПоказатьПредупреждение(, ТекстПредупреждение);

КонецПроцедуры

&НаСервере
Функция ПодключениеКШтрафовНетДоступно()
	
	ТекстОшибки = "";
	ИнформацияОбАккаунте = уатИнтеграции_проф.ШтрафовНет_ИнформацияОбАккаунте(Объект, ТекстОшибки);

	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ШтрафовНет_ПолучитьСписокКомпаний()
	
	ТекстОшибки = "";
	СписокКомпаний = уатИнтеграции_проф.ШтрафовНет_СписокКомпаний(Объект, ТекстОшибки);
	Элементы.Компания.СписокВыбора.Очистить();
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		МассивКомпаний = СписокКомпаний.Получить("companies");
		Если ТипЗнч(МассивКомпаний) = Тип("Массив") Тогда
			Для Каждого ТекКомпания Из МассивКомпаний Цикл
				IDКомпании            = ТекКомпания.Получить("id");
				НаименованиеКомпании  = ТекКомпания.Получить("display_name");
				Элементы.Компания.СписокВыбора.Добавить(IDКомпании, НаименованиеКомпании);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ШтрафовНет_ПолучитьСписокАвтопарков()
	
	ТекстОшибки = "";
	СписокАвтопарков = уатИнтеграции_проф.ШтрафовНет_СписокАвтопарков(Объект, ТекстОшибки);
	
	Элементы.Автопарк.СписокВыбора.Очистить();
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		МассивАвтопарков = СписокАвтопарков.Получить("units");
		Если ТипЗнч(МассивАвтопарков) = Тип("Массив") Тогда
			Для Каждого ТекАвтосервис Из МассивАвтопарков Цикл
				IDАвтопарк            = ТекАвтосервис.Получить("id");
				НаименованиеАвтопарка = ТекАвтосервис.Получить("name");
				Элементы.Автопарк.СписокВыбора.Добавить(IDАвтопарк, НаименованиеАвтопарка);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()  
	
	Элементы.Контрагент.Видимость         = Объект.ЗагрузкаПроездовПоЦКАДвОтчетыСистемыАвтодор;
	Элементы.ДоговорКонтрагента.Видимость = Объект.ЗагрузкаПроездовПоЦКАДвОтчетыСистемыАвтодор; 
	
	Если Объект.ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ШтрафовНет") Тогда
		
		Элементы.АдресСервиса.ПодсказкаВвода = НСтр("ru = 'Например: https://api.b2b.shtrafovnet.ru'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДругуюОсновнуюУчеткуШтрафовСвязаннуюСКомпанией(Ссылка, IDКомпании, АдресСервиса)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	уатУчетныеЗаписиСервисовШтрафов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.уатУчетныеЗаписиСервисовШтрафов КАК уатУчетныеЗаписиСервисовШтрафов
	               |ГДЕ
	               |	уатУчетныеЗаписиСервисовШтрафов.Ссылка <> &Ссылка
	               |	И уатУчетныеЗаписиСервисовШтрафов.ШтрафСвязанСКомпанией
	               |	И уатУчетныеЗаписиСервисовШтрафов.IDКомпании = &IDКомпании
	               |	И уатУчетныеЗаписиСервисовШтрафов.АдресСервиса ПОДОБНО &АдресСервиса";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("IDКомпании",   IDКомпании);
	Запрос.УстановитьПараметр("АдресСервиса", АдресСервиса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДругуюОсновнуюУчеткуШтрафовСвязаннуюСВодителем(Ссылка, IDКомпании, АдресСервиса)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	уатУчетныеЗаписиСервисовШтрафов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.уатУчетныеЗаписиСервисовШтрафов КАК уатУчетныеЗаписиСервисовШтрафов
	               |ГДЕ
	               |	уатУчетныеЗаписиСервисовШтрафов.Ссылка <> &Ссылка
	               |	И уатУчетныеЗаписиСервисовШтрафов.ШтрафСвязанСВодителем
	               |	И уатУчетныеЗаписиСервисовШтрафов.IDКомпании = &IDКомпании
	               |	И уатУчетныеЗаписиСервисовШтрафов.АдресСервиса ПОДОБНО &АдресСервиса";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("IDКомпании",   IDКомпании);
	Запрос.УстановитьПараметр("АдресСервиса", АдресСервиса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ИзменениеКонтрагентаСервер(ДанныеДляЗаполнения)
	СтруктураПараметровДляПолученияДоговора =
		уатЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПокупки();
	
	ЗначенияДляЗаполнения = уатОбщегоНазначенияСервер.ПриИзмененииЗначенияКонтрагента(ДанныеДляЗаполнения,
							СтруктураПараметровДляПолученияДоговора);
	Возврат ЗначенияДляЗаполнения;
КонецФункции

&НаСервере
Процедура УстановитьСвязиПараметровВыбора()
	
	НовыйМассив = Новый Массив();
	
	НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Организация", "Объект.Организация");
	НовыйМассив.Добавить(НоваяСвязь);
	
	НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Контрагент");
	НовыйМассив.Добавить(НоваяСвязь);
	
	Элементы.ДоговорКонтрагента.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКонтрагентаИлиОрганизации()
	
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	ДанныеОбменаССервером.Дата = ТекущаяДата();
	
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	Объект.ДоговорКонтрагента = ЗначенияДляЗаполнения.ДоговорКонтрагента;  
	
	ДоговорПередИзменением = Договор;
	Договор = Объект.ДоговорКонтрагента;
	
	УстановитьСвязиПараметровВыбора();
	
КонецПроцедуры

#КонецОбласти

